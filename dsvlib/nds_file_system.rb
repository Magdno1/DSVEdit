
require 'fileutils'

class NDSFileSystem
  class InvalidFileError < StandardError ; end
  class ConversionError < StandardError ; end
  class OffsetPastEndOfFileError < StandardError ; end
  class FileExpandError < StandardError ; end
  
  attr_reader :files,
              :files_by_path,
              :files_by_index,
              :overlays,
              :rom
  
  def open_directory(filesystem_directory)
    @filesystem_directory = filesystem_directory
    input_rom_path = "#{@filesystem_directory}/ftc/rom.nds"
    @rom = File.open(input_rom_path, "rb") {|file| file.read}
    read_from_rom()
    @files.each do |id, file|
      next unless file[:type] == :file
      
      file[:size] = File.size(File.join(@filesystem_directory, file[:file_path]))
      file[:end_offset] = file[:start_offset] + file[:size]
    end
    get_file_ram_start_offsets_and_file_data_types()
  end
  
  def open_and_extract_rom(input_rom_path, filesystem_directory)
    @filesystem_directory = filesystem_directory
    @rom = File.open(input_rom_path, "rb") {|file| file.read}
    read_from_rom()
    extract_to_hard_drive()
    get_file_ram_start_offsets_and_file_data_types()
  end
  
  def open_rom(input_rom_path)
    @filesystem_directory = nil
    @rom = File.open(input_rom_path, "rb") {|file| file.read}
    read_from_rom()
    extract_to_memory()
    get_file_ram_start_offsets_and_file_data_types()
  end
  
  def write_to_rom(output_rom_path)
    print "Writing files to #{output_rom_path}... "
    
    new_rom = @rom.dup
    
    expanded_files = []
    max_written_address = 0
    
    files_written = 0
    files_without_dirs.sort_by{|id, file| id}.each do |id, file|
      file_data = get_file_data_from_opened_files_cache(file[:file_path])
      new_file_size = file_data.length
      
      offset = file[:id]*8
      old_start_offset, old_end_offset = @rom[@file_allocation_table_offset+offset, 8].unpack("VV")
      old_size = old_end_offset - old_start_offset
      if new_file_size > old_size
        expanded_files << file
        next
      end
      
      new_start_offset = old_start_offset
      new_end_offset = new_start_offset + new_file_size
      new_rom[new_start_offset,new_file_size] = file_data
      offset = file[:id]*8
      new_rom[@file_allocation_table_offset+offset, 8] = [new_start_offset, new_end_offset].pack("VV")
      max_written_address = new_end_offset if new_end_offset > max_written_address
      
      # Update the lengths of changed overlay files.
      if file[:overlay_id]
        offset = file[:overlay_id] * 32
        new_rom[@arm9_overlay_table_offset+offset+8, 4] = [new_file_size].pack("V")
      end
      
      files_written += 1
      if block_given?
        yield(files_written)
      end
    end
    
    expanded_files.each do |file|
      file_data = get_file_data_from_opened_files_cache(file[:file_path])
      new_file_size = file_data.length
      
      new_start_offset = max_written_address
      new_end_offset = new_start_offset + new_file_size
      
      new_rom[new_start_offset,new_file_size] = file_data
      offset = file[:id]*8
      new_rom[@file_allocation_table_offset+offset, 8] = [new_start_offset, new_end_offset].pack("VV")
      max_written_address = new_end_offset if new_end_offset > max_written_address
      
      # Update the lengths of changed overlay files.
      if file[:overlay_id]
        offset = file[:overlay_id] * 32
        new_rom[@arm9_overlay_table_offset+offset+8, 4] = [new_file_size].pack("V")
      end
      
      files_written += 1
      if block_given?
        yield(files_written)
      end
    end
    
    # Update arm9
    file = @extra_files.find{|file| file[:name] == "arm9.bin"}
    file_data = get_file_data_from_opened_files_cache(file[:file_path])
    new_file_size = file_data.length
    if @arm9_size != new_file_size
      raise "ARM9 changed size"
    end
    new_rom[file[:start_offset], file[:size]] = file_data
    
    File.open(output_rom_path, "wb") do |f|
      f.write(new_rom)
    end
    puts "Done"
  end
  
  def all_files
    @files.values + @extra_files
  end
  
  def print_files
    @files.each do |id, file|
      puts "%02X" % id
      puts file.inspect
      gets
    end
  end
  
  def load_overlay(overlay_id)
    overlay = @overlays[overlay_id]
    load_file(overlay)
  end
  
  def load_file(file)
    @currently_loaded_files[file[:ram_start_offset]] = file
  end
  
  def convert_ram_address_to_path_and_offset(ram_address)
    @currently_loaded_files.each do |ram_start_offset, file|
      ram_range = (file[:ram_start_offset]..file[:ram_start_offset]+file[:size]-1)
      if ram_range.include?(ram_address)
        offset_in_file = ram_address - file[:ram_start_offset]
        return [file[:file_path], offset_in_file]
      end
    end
    
    str = ""
    @currently_loaded_files.each do |ram_start_offset, file|
      if file[:overlay_id]
        str << "\n overlay loaded: %02d" % file[:overlay_id]
      end
      str << "\n ram_range: %08X..%08X" % [file[:ram_start_offset], file[:ram_start_offset]+file[:size]]
      str << "\n rom_start: %08X" % file[:start_offset]
    end
    raise ConversionError.new("Failed to convert ram address to rom address: %08X. #{str}" % ram_address)
  end
  
  def read(ram_address, length=1, options={})
    file_path, offset_in_file = convert_ram_address_to_path_and_offset(ram_address)
    return read_by_file(file_path, offset_in_file, length, options)
  end
  
  def read_by_file(file_path, offset_in_file, length, options={})
    file = files_by_path[file_path]
    
    if options[:allow_length_to_exceed_end_of_file]
      max_offset = offset_in_file
    else
      max_offset = offset_in_file + length
    end
    if max_offset > file[:size]
      if options[:allow_reading_into_next_file_in_ram] && file[:ram_start_offset]
        next_file_in_ram = find_file_by_ram_start_offset(file[:ram_start_offset]+0xC)
        if next_file_in_ram
          return read_by_file(next_file_in_ram[:file_path], offset_in_file - file[:size], length, options=options)
        end
      end
      
      raise OffsetPastEndOfFileError.new("Offset %08X (length %08X) is past end of file #{file_path} (%08X bytes long)" % [offset_in_file, length, file[:size]])
    end
    
    file_data = get_file_data_from_opened_files_cache(file_path)
    return file_data[offset_in_file, length]
  end
  
  def read_until_end_marker(ram_address, end_markers)
    file_path, offset_in_file = convert_ram_address_to_path_and_offset(ram_address)
    file_data = get_file_data_from_opened_files_cache(file_path)
    substring = file_data[offset_in_file..-1]
    end_index = substring.index(end_markers.pack("C*"))
    return substring[0,end_index]
  end
  
  def write(ram_address, new_data)
    file_path, offset_in_file = convert_ram_address_to_path_and_offset(ram_address)
    write_by_file(file_path, offset_in_file, new_data)
  end
  
  def write_by_file(file_path, offset_in_file, new_data)
    file = files_by_path[file_path]
    if offset_in_file + new_data.length > file[:size]
      raise OffsetPastEndOfFileError.new("Offset %08X is past end of file #{file_path} (%08X bytes long)" % [offset_in_file, file[:size]])
    end
    
    file_data = get_file_data_from_opened_files_cache(file_path)
    file_data[offset_in_file, new_data.length] = new_data
    @opened_files_cache[file_path] = file_data
    @uncommitted_files << file_path
  end
  
  def find_file_by_ram_start_offset(ram_start_offset)
    files.values.find do |file|
      file[:type] == :file && file[:ram_start_offset] == ram_start_offset
    end
  end
  
  def commit_file_changes(base_directory = @filesystem_directory)
    print "Committing changes to filesystem... "
    
    @uncommitted_files.each do |file_path|
      file_data = get_file_data_from_opened_files_cache(file_path)
      full_path = File.join(base_directory, file_path)
      
      full_dir = File.dirname(full_path)
      FileUtils.mkdir_p(full_dir)
      
      File.open(full_path, "wb") do |f|
        f.write(file_data)
      end
    end
    @uncommitted_files = []
    
    puts "Done."
  end
  
  def has_uncommitted_files?
    !@uncommitted_files.empty?
  end
  
  def expand_file_and_get_end_of_file_ram_address(ram_address, length_to_expand_by)
    file_path, offset_in_file = convert_ram_address_to_path_and_offset(ram_address)
    file = @currently_loaded_files.values.find{|file| file[:file_path] == file_path}
    
    if file[:overlay_id] && ROOM_OVERLAYS.include?(file[:overlay_id]) && file[:size] + length_to_expand_by > MAX_ALLOWABLE_ROOM_OVERLAY_SIZE
      raise FileExpandError.new("Failed to expand room overlay #{file[:overlay_id]} to #{file[:size] + length_to_expand_by} bytes because that is larger than the maximum size a room overlay can be in this game (#{MAX_ALLOWABLE_ROOM_OVERLAY_SIZE} bytes).")
    end
    
    old_size = file[:size]
    file[:size] += length_to_expand_by
    
    # Expand the actual file data string, and fill it with 0 bytes.
    write_by_file(file_path, old_size, "\0"*length_to_expand_by)
    
    return file[:ram_start_offset] + old_size
  end
  
  def files_without_dirs
    files.select{|id, file| file[:type] == :file}
  end
  
private
  
  def read_from_rom
    @game_name = @rom[0x00,12]
    raise InvalidFileError.new("Not a DSVania") unless %w(CASTLEVANIA1 CASTLEVANIA2 CASTLEVANIA3).include?(@game_name)
    @game_code = @rom[0x0C,4]
    raise InvalidFileError.new("Only the North American versions are supported") unless %w(ACVE ACBE YR9E).include?(@game_code)
    
    @arm9_rom_offset, @arm9_entry_address, @arm9_ram_offset, @arm9_size = @rom[0x20,16].unpack("VVVV")
    @arm7_rom_offset, @arm7_entry_address, @arm7_ram_offset, @arm7_size = @rom[0x30,16].unpack("VVVV")
    
    @file_name_table_offset, @file_name_table_size, @file_allocation_table_offset, @file_allocation_table_size = @rom[0x40,16].unpack("VVVV")
    
    @arm9_overlay_table_offset, @arm9_overlay_table_size = @rom[0x50,8].unpack("VV")
    @arm7_overlay_table_offset, @arm7_overlay_table_size = @rom[0x58,8].unpack("VV")
    
    @banner_start_offset = @rom[0x68,4].unpack("V").first
    @banner_end_offset = @banner_start_offset + 0x840 # ??
    
    @files = {}
    @overlays = []
    @currently_loaded_files = {}
    @opened_files_cache = {}
    @uncommitted_files = []
    
    get_file_name_table()
    get_overlay_table()
    get_file_allocation_table()
    get_extra_files()
    generate_file_paths()
    CONSTANT_OVERLAYS.each do |overlay_index|
      load_overlay(overlay_index)
    end
  end
  
  def extract_to_hard_drive
    print "Extracting files from ROM... "
    
    all_files.each do |file|
      next unless file[:type] == :file
      #next unless (file[:overlay_id] || file[:name] == "arm9.bin" || file[:name] == "rom.nds")
      
      start_offset, end_offset, file_path = file[:start_offset], file[:end_offset], file[:file_path]
      file_data = @rom[start_offset..end_offset-1]
      
      output_path = File.join(@filesystem_directory, file_path)
      output_dir = File.dirname(output_path)
      FileUtils.mkdir_p(output_dir)
      File.open(output_path, "wb") do |f|
        f.write(file_data)
      end
    end
    
    puts "Done."
  end
  
  def extract_to_memory
    print "Extracting files from ROM to memory... "
    
    all_files.each do |file|
      next unless file[:type] == :file
      
      start_offset, end_offset, file_path = file[:start_offset], file[:end_offset], file[:file_path]
      file_data = @rom[start_offset..end_offset-1]
      
      @opened_files_cache[file_path] = file_data
    end
    
    puts "Done."
  end
  
  def get_file_data_from_opened_files_cache(file_path)
    if @opened_files_cache[file_path]
      file_data = @opened_files_cache[file_path]
    else
      path = File.join(@filesystem_directory, file_path)
      file_data = File.open(path, "rb") {|file| file.read}
      @opened_files_cache[file_path] = file_data
    end
    
    return file_data
  end
  
  def get_file_name_table
    file_name_table_data = @rom[@file_name_table_offset, @file_name_table_size]
    
    subtable_offset, subtable_first_file_id, number_of_dirs = file_name_table_data[0x00,8].unpack("Vvv")
    get_file_name_subtable(subtable_offset, subtable_first_file_id, 0xF000)
    
    i = 1
    while i < number_of_dirs
      subtable_offset, subtable_first_file_id, parent_dir_id = file_name_table_data[0x00+i*8,8].unpack("Vvv")
      get_file_name_subtable(subtable_offset, subtable_first_file_id, 0xF000 + i)
      i += 1
    end
  end
  
  def get_file_name_subtable(subtable_offset, subtable_first_file_id, parent_dir_id)
    i = 0
    offset = @file_name_table_offset + subtable_offset
    next_file_id = subtable_first_file_id
    
    while true
      length = @rom[offset,1].unpack("C*").first
      offset += 1
      
      case length
      when 0x01..0x7F
        type = :file
        
        name = @rom[offset,length]
        offset += length
        
        id = next_file_id
        next_file_id += 1
      when 0x81..0xFF
        type = :subdir
        
        length = length & 0x7F
        name = @rom[offset,length]
        offset += length
        
        id = @rom[offset,2].unpack("v").first
        offset += 2
      when 0x00
        # end of subtable
        break
      when 0x80
        # reserved
        break
      end
      
      @files[id] = {:name => name, :type => type, :parent_id => parent_dir_id, :id => id}
      i += 1
    end
  end
  
  def get_overlay_table
    overlay_table_data = @rom[@arm9_overlay_table_offset, @arm9_overlay_table_size]
    
    offset = 0x00
    while offset < @arm9_overlay_table_size
      overlay_id, overlay_ram_address, overlay_size, _, _, _, file_id, _ = overlay_table_data[0x00+offset,32].unpack("V*")
      
      @files[file_id] = {:name => "overlay9_#{overlay_id}", :type => :file, :id => file_id, :overlay_id => overlay_id, :ram_start_offset => overlay_ram_address, :size => overlay_size}
      @overlays << @files[file_id]
      
      offset += 32
    end
  end
  
  def get_file_ram_start_offsets_and_file_data_types
    @files_by_index = []
    offset = LIST_OF_FILE_RAM_LOCATIONS_START_OFFSET
    while offset < LIST_OF_FILE_RAM_LOCATIONS_END_OFFSET
      file_data = read(offset, LIST_OF_FILE_RAM_LOCATIONS_ENTRY_LENGTH)
      
      ram_start_offset = file_data[0..3].unpack("V").first
      
      file_data_type = file_data[4..5].unpack("v").first
      
      file_path = file_data[6..-1]
      file_path = file_path.delete("\x00") # Remove null bytes padding the end of the string
      file = files_by_path[file_path]
      
      file[:ram_start_offset] = ram_start_offset
      file[:file_data_type] = file_data_type
      
      @files_by_index << file
      
      offset += LIST_OF_FILE_RAM_LOCATIONS_ENTRY_LENGTH
    end
    
    if GAME == "por"
      # Richter's gfx files don't have a ram offset stored in the normal place.
      i = 0
      files.values.each do |file|
        if file[:ram_start_offset] == 0 && file[:file_path] =~ /\/sc2\/s0_ri_..\.dat/
          file[:ram_start_offset] = read(RICHTERS_LIST_OF_GFX_POINTERS + i*4, 4).unpack("V").first
          i += 1
        end
      end
    end
  end
  
  def get_file_allocation_table
    file_allocation_table_data = @rom[@file_allocation_table_offset, @file_allocation_table_size]
    
    id = 0x00
    offset = 0x00
    while offset < @file_allocation_table_size
      @files[id][:start_offset], @files[id][:end_offset] = file_allocation_table_data[offset,8].unpack("VV")
      @files[id][:size] = @files[id][:end_offset] - @files[id][:start_offset]
      
      id += 1
      offset += 0x08
    end
  end
  
  def get_extra_files
    @extra_files = []
    @extra_files << {:name => "ndsheader.bin", :type => :file, :start_offset => 0x0, :end_offset => 0x4000}
    arm9_file = {:name => "arm9.bin", :type => :file, :start_offset => @arm9_rom_offset, :end_offset => @arm9_rom_offset + @arm9_size, :ram_start_offset => @arm9_ram_offset, :size => @arm9_size}
    @extra_files << arm9_file
    load_file(arm9_file)
    @extra_files << {:name => "arm7.bin", :type => :file, :start_offset => @arm7_rom_offset, :end_offset => @arm7_rom_offset + @arm7_size}
    @extra_files << {:name => "arm9_overlay_table.bin", :type => :file, :start_offset => @arm9_overlay_table_offset, :end_offset => @arm9_overlay_table_offset + @arm9_overlay_table_size}
    @extra_files << {:name => "arm7_overlay_table.bin", :type => :file, :start_offset => @arm7_overlay_table_offset, :end_offset => @arm7_overlay_table_offset + @arm7_overlay_table_size}
    @extra_files << {:name => "fnt.bin", :type => :file, :start_offset => @file_name_table_offset, :end_offset => @file_name_table_offset + @file_name_table_size}
    @extra_files << {:name => "fat.bin", :type => :file, :start_offset => @file_allocation_table_offset, :end_offset => @file_allocation_table_offset + @file_allocation_table_size}
    @extra_files << {:name => "banner.bin", :type => :file, :start_offset => @banner_start_offset, :end_offset => @banner_end_offset}
    @extra_files << {:name => "rom.nds", :type => :file, :start_offset => 0, :end_offset => @rom.length}
  end
  
  def generate_file_paths
    @files_by_path = {}
    
    all_files.each do |file|
      if file[:parent_id] == 0xF000
        file[:file_path] = file[:name]
      elsif file[:parent_id].nil?
        file[:file_path] = File.join("/ftc", file[:name])
      else
        file[:file_path] = "/" + File.join(@files[file[:parent_id]][:name], file[:name])
      end
      
      @files_by_path[file[:file_path]] = file
    end
  end
end
