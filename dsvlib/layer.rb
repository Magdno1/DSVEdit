class Layer
  class LayerReadError < StandardError ; end
  
  SIZE_OF_A_SCREEN_IN_BYTES = 2*16*12
  
  attr_reader :room,
              :fs
              
  attr_accessor :layer_list_entry_ram_pointer,
                :layer_metadata_ram_pointer,
                :z_index,
                :scroll_mode,
                :opacity,
                :render_type,
                :width,
                :height,
                :ram_pointer_to_tileset_for_layer,
                :collision_tileset_ram_pointer,
                :layer_tiledata_ram_start_offset,
                :tiles
  
  def initialize(room, layer_list_entry_ram_pointer, fs)
    @room = room
    @layer_list_entry_ram_pointer = layer_list_entry_ram_pointer
    @fs = fs
  end
  
  def read_from_rom
    read_from_layer_list_entry()
    read_from_layer_metadata()
    read_from_layer_tiledata()
  end
  
  def read_from_layer_list_entry
    @z_index, @scroll_mode, @opacity, _, _, 
      @render_type, _, _, _,
      @layer_metadata_ram_pointer = fs.read(layer_list_entry_ram_pointer, 16).unpack("CCCCVCCCCV")
  end
  
  def read_from_layer_metadata
    @width, @height, _,
      @ram_pointer_to_tileset_for_layer,
      @collision_tileset_ram_pointer,
      @layer_tiledata_ram_start_offset = fs.read(layer_metadata_ram_pointer,16).unpack("CCvVVV")
    
    if width > 15 || height > 15
      raise LayerReadError.new("Invalid layer size: #{width}x#{height}")
    end
  end
  
  def read_from_layer_tiledata
    tile_data_string = fs.read(layer_tiledata_ram_start_offset, SIZE_OF_A_SCREEN_IN_BYTES*width*height)
    @tiles = tile_data_string.unpack("v*").map do |tile_data|
      Tile.new.from_game_data(tile_data)
    end
  end
  
  def write_to_rom
    room.sector.load_necessary_overlay()
    
    # Clamp width/height to valid values.
    @width = [@width, 15].min
    @width = [@width, 1].max
    @height = [@height, 15].min
    @height = [@height, 1].max
    
    old_width, old_height = fs.read(layer_metadata_ram_pointer,2).unpack("C*")
    
    if (width*height) > (old_width*old_height)
      # Size of layer was increased. Repoint to end of file so nothing is overwritten.
      
      blocks_in_room = width * 16 * height * 12
      bytes_in_tiledata = blocks_in_room * 2
      
      new_tiledata_ram_pointer = fs.expand_file_and_get_end_of_file_ram_address(layer_tiledata_ram_start_offset, bytes_in_tiledata)
      fs.write(layer_metadata_ram_pointer+12, [new_tiledata_ram_pointer].pack("V"))
      @layer_tiledata_ram_start_offset = new_tiledata_ram_pointer
    end
    
    if width != old_width || height != old_height
      old_width_in_blocks = old_width * 16
      width_in_blocks = width * 16
      height_in_blocks = height * 12
      
      if old_width_in_blocks == 0
        # New layer.
        tile_rows = []
      else
        tile_rows = tiles.each_slice(old_width_in_blocks).to_a
      end
      
      # Truncate the layer vertically if the layer's height was decreased.
      tile_rows = tile_rows[0, height_in_blocks]
      
      (height_in_blocks - tile_rows.length).times do
        # Pad the layer with empty blocks vertically if layer's height was increased.
        new_row = []
        width_in_blocks.times do
          new_row << Tile.new.from_game_data(0)
        end
        tile_rows << new_row
      end
      
      tile_rows.map! do |row|
        # Truncate the layer horizontally if the layer's width was decreased.
        row = row[0, width_in_blocks]
        
        (width_in_blocks - row.length).times do
          # Pad the layer with empty blocks horizontally if layer's width was increased.
          row << Tile.new.from_game_data(0)
        end
        
        row
      end
      
      @tiles = tile_rows.flatten
    end
    
    fs.write(layer_metadata_ram_pointer, [width, height].pack("CC"))
    fs.write(layer_metadata_ram_pointer+4, [ram_pointer_to_tileset_for_layer, collision_tileset_ram_pointer].pack("VV"))
    fs.write(layer_list_entry_ram_pointer, [z_index, scroll_mode, opacity].pack("CCC"))
    fs.write(layer_list_entry_ram_pointer+6, [height*0xC0].pack("v")) if GAME == "dos"
    fs.write(layer_list_entry_ram_pointer+8, [render_type].pack("C"))
    fs.write(layer_list_entry_ram_pointer+12, [layer_metadata_ram_pointer].pack("V"))
    tile_data = tiles.map(&:to_tile_data).pack("v*")
    fs.write(layer_tiledata_ram_start_offset, tile_data)
  end
  
  def colors_per_palette
    colors = 16
    if render_type > 1
      colors = 256
    end
    
    return colors
  end
  
  def tileset_filename
    if room.graphic_tilesets_for_room
      tileset_gfx_file_ids = room.graphic_tilesets_for_room.map{|file| file[:id]}.join(",")
    else
      tileset_gfx_file_ids = "none"
    end
    "tileset_%08X_%08X_%s_%d" % [ram_pointer_to_tileset_for_layer, room.palette_offset || 0, tileset_gfx_file_ids, colors_per_palette]
  end
end

class Tile
  attr_accessor :index_on_tileset,
                :horizontal_flip,
                :vertical_flip
  
  def from_game_data(tile_data)
    @index_on_tileset = (tile_data & 0b0011111111111111)
    @horizontal_flip  = (tile_data & 0b0100000000000000) != 0
    @vertical_flip    = (tile_data & 0b1000000000000000) != 0
    
    return self
  end
  
  def to_tile_data
    tile_data = index_on_tileset
    tile_data |= 0b0100000000000000 if horizontal_flip
    tile_data |= 0b1000000000000000 if vertical_flip
    tile_data
  end
end
