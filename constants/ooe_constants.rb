
GAME = "ooe"
LONG_GAME_NAME = "Order of Ecclesia"

AREA_LIST_RAM_START_OFFSET = 0x020ECDDC

# Overlays 40 to 85.
AREA_INDEX_TO_OVERLAY_INDEX = {
  0 => {
    0 => 65,
    1 => 66,
    2 => 68,
    3 => 69,
    4 => 70,
    5 => 71,
    6 => 72,
    7 => 73,
    8 => 76,
    9 => 77,
    10 => 74,
    11 => 75,
    12 => 67,
  },
  1 => {
    0 => 40,
    1 => 41,
  },
  2 => {
    0 => 42,
  },
  3 => {
    0 => 43,
  },
  4 => {
    0 => 44,
  },
  5 => {
    0 => 45,
  },
  6 => {
    0 => 46,
    1 => 47,
  },
  7 => {
    0 => 48,
    1 => 49,
  },
  8 => {
    0 => 50,
    1 => 51,
    2 => 52,
  },
  9 => {
    0 => 53,
  },
  10 => {
    0 => 54,
    1 => 55,
  },
  11 => {
    0 => 56,
    1 => 57,
  },
  12 => {
    0 => 58,
  },
  13 => {
    0 => 59,
  },
  14 => {
    0 => 60,
  },
  15 => {
    0 => 61,
  },
  16 => {
    0 => 62,
    1 => 63,
  },
  17 => {
    0 => 64,
  },
  18 => {
    0 => 78,
    1 => 79,
  },
  19 => {
    0 => 80,
    1 => 81,
    2 => 82,
    3 => 83,
    4 => 84,
    5 => 85,
  }
}

AREA_INDEX_TO_AREA_NAME = {
   0 => "Dracula's Castle",
   1 => "Wygol Village",
   2 => "Ecclesia",
   3 => "Training Chamber",
   4 => "Ruvas Forest",
   5 => "Argila Swamp",
   6 => "Kalidus Channel",
   7 => "Somnus Reef",
   8 => "Minera Prison Island",
   9 => "Lighthouse",
  10 => "Tymeo Mountains",
  11 => "Tristis Pass",
  12 => "Large Cavern",
  13 => "Giant's Dwelling",
  14 => "Mystery Manor",
  15 => "Misty Forest Road",
  16 => "Oblivion Ridge",
  17 => "Skeleton Cave",
  18 => "Monastery",
  19 => "Epilogue & Boss Rush Mode & Practice Mode"
}

SECTOR_INDEX_TO_SECTOR_NAME = {
  0 => {
     0 => "Castle Entrance",
     1 => "Castle Entrance",
     2 => "Underground Labyrinth",
     3 => "Library",
     4 => "Library",
     5 => "Barracks",
     6 => "Mechanical Tower",
     7 => "Mechanical Tower",
     8 => "Arms Depot",
     9 => "Forsaken Cloister",
    10 => "Final Approach",
    11 => "Final Approach",
    12 => "Castle Entrance",
  },
}

ENTITY_TYPE_DESCRIPTIONS = {
  0 => "Nothing",
  1 => "Enemy",
  2 => "Special object",
  3 => "Candle",
  4 => "Pickup",
  5 => "???",
  6 => "???",
  7 => "Hidden pickup",
  8 => "Entity hider",
  9 => "???",
}

CONSTANT_OVERLAYS = [19, 22]

ROOM_OVERLAYS = (40..85)
MAX_ALLOWABLE_ROOM_OVERLAY_SIZE = 168384

INVALID_ROOMS = []

MAP_TILE_METADATA_LIST_START_OFFSET = 0x020ECE84
MAP_TILE_LINE_DATA_LIST_START_OFFSET = 0x020ECED8
MAP_LENGTH_DATA_START_OFFSET = 0x020B61C0
MAP_SECRET_DOOR_LIST_START_OFFSET = 0x020ECD3C

AREA_MUSIC_LIST_START_OFFSET = 0x020D79D8
SECTOR_MUSIC_LIST_START_OFFSET = 0x020D7954

MAP_FILL_COLOR = [160, 64, 128, 255]
MAP_SAVE_FILL_COLOR = [248, 0, 0, 255]
MAP_WARP_FILL_COLOR = [0, 0, 248, 255]
MAP_SECRET_FILL_COLOR = [0, 128, 0, 255]
MAP_ENTRANCE_FILL_COLOR = [248, 128, 0, 255]
MAP_LINE_COLOR = [248, 248, 248, 255]
MAP_DOOR_COLOR = [216, 216, 216, 255]
MAP_DOOR_CENTER_PIXEL_COLOR = [0, 0, 0, 0]
MAP_SECRET_DOOR_COLOR = [248, 248, 0, 255]

LIST_OF_FILE_RAM_LOCATIONS_START_OFFSET = 0x020D8CEC
LIST_OF_FILE_RAM_LOCATIONS_END_OFFSET = 0x020ECA0B
LIST_OF_FILE_RAM_LOCATIONS_ENTRY_LENGTH = 0x20

COLOR_OFFSETS_PER_256_PALETTE_INDEX = 256

ITEM_LOCAL_ID_RANGES = {}
ITEM_GLOBAL_ID_RANGE = (0x70..0x162) # includes relics
GLYPH_GLOBAL_ID_RANGE = (0x02..0x50)

PICKUP_SUBTYPES_FOR_ITEMS = (0xFF..0xFF)
PICKUP_SUBTYPES_FOR_SKILLS = (0x02..0x04)

ENEMY_IDS = (0x00..0x78)
COMMON_ENEMY_IDS = (0x00..0x6A).to_a
BOSS_IDS = (0x6B..0x78).to_a
RANDOMIZABLE_BOSS_IDS = BOSS_IDS - [0x76] # remove eligor, he needs his own huge room

BOSS_DOOR_SUBTYPE = 0x4B
BOSS_ID_TO_BOSS_DOOR_VAR_B = {
  0x6B => 0x02, # giant skeleton
  0x6C => 0x01, # arthroverta
  0x6D => 0x03, # brachyura
  0x6E => 0x04, # man eater
  0x6F => 0x05, # rusalka
  0x70 => 0x06, # goliath
  0x71 => 0x07, # gravedorcus
  0x72 => 0x08, # albus
  0x73 => 0x09, # barlowe
  0x74 => 0x0A, # wallman
  0x75 => 0x0B, # blackmore
  0x76 => 0x0C, # eligor
  0x77 => 0x0D, # death
  0x78 => 0x0F, # dracula
}

ENEMY_DNA_RAM_START_OFFSET = 0x020B6364
ENEMY_DNA_LENGTH = 36
ENEMY_DNA_FORMAT = [
  [4, "Init AI"],
  [4, "Running AI"],
  [2, "Item 1"],
  [2, "Item 2"],
  [1, "Unknown 1"],
  [1, "Unknown 2"],
  [2, "HP"],
  [2, "EXP"],
  [2, "Unknown 3"],
  [2, "Glyph"],
  [1, "Glyph Chance"],
  [1, "Attack"],
  [1, "Unknown 4"],
  [1, "Unknown 5"],
  [1, "Item 1 Chance"],
  [1, "Item 2 Chance"],
  [2, "Weaknesses", :bitfield],
  [2, "Unknown 6"],
  [2, "Resistances", :bitfield],
  [2, "Unknown 7"],
]
ENEMY_DNA_BITFIELD_ATTRIBUTES = {
  "Weaknesses" => [
    "Strike",
    "Slash",
    "Fire",
    "Ice",
    "Lightning",
    "Holy",
    "Dark",
    "Weakness 8",
    "Poison",
    "Curse",
    "Stone",
    "Torpor",
    "Weakness 13",
    "Weakness 14",
    "Weakness 15",
    "Made of flesh",
  ],
  "Resistances" => [
    "Strike",
    "Slash",
    "Fire",
    "Ice",
    "Lightning",
    "Holy",
    "Dark",
    "Resistance 8",
    "Poison",
    "Curse",
    "Stone",
    "Resistance 12",
    "Resistance 13",
    "Resistance 14",
    "Resistance 15",
    "Resistance 16",
  ],
}

# Overlays 24 to 38 are used for enemies.
OVERLAY_FILE_FOR_ENEMY_AI = {
  0x16 => 38, # the creature
  0x3C => 38, # owl
  0x41 => 38, # owl knight
  0x4E => 38, # draculina
  0x5E => 38, # spectral sword
  0x66 => 36, # final knight
  0x67 => 29, # jiang shi
  0x6C => 24, # arthroverta
  0x6D => 30, # brachyura
  0x6E => 26, # maneater
  0x6F => 27, # rusalka
  0x70 => 32, # goliath
  0x71 => 33, # gravedorcus
  0x72 => 36, # albus
  0x73 => 37, # barlowe
  0x74 => 28, # wallman
  0x75 => 35, # blackmore
  0x76 => 31, # eligor
  0x77 => 25, # death
  0x78 => [34, 75], # dracula. His palette is actually stored in one of the area overlays (75) instead of his enemy overlay (34).
}
REUSED_ENEMY_INFO = {
  0x23 => {init_code: 0x022505AC, gfx_sheet_ptr_index: 1, palette_offset: 0, palette_list_ptr_index: 1}, # black fomor -> white fomor
  0x30 => {init_code:        nil, gfx_sheet_ptr_index: 0, palette_offset: 3, palette_list_ptr_index: 0}, # ladycat
  0x34 => {init_code: 0x0228D23C, gfx_sheet_ptr_index: 0, palette_offset: 0, palette_list_ptr_index: 0}, # automaton zx26
  0x48 => {init_code: 0x0224E468, gfx_sheet_ptr_index: 1, palette_offset: 0, palette_list_ptr_index: 1}, # ghoul -> zombie
  0x4C => {init_code: 0x0228BBBC, gfx_sheet_ptr_index: 0, palette_offset: 0, palette_list_ptr_index: 0}, # black panther -> ladycat
  0x50 => {init_code:        nil, gfx_sheet_ptr_index: 0, palette_offset: 1, palette_list_ptr_index: 0}, # polkir
  0x54 => {init_code:        nil, gfx_sheet_ptr_index: 0, palette_offset: 3, palette_list_ptr_index: 0}, # gurkha master
  0x5D => {init_code: 0x02241FD4, gfx_sheet_ptr_index: 0, palette_offset: 0, palette_list_ptr_index: 0}, # bugbear
  0x5F => {init_code: 0x0228D23C, gfx_sheet_ptr_index: 0, palette_offset: 0, palette_list_ptr_index: 0}, # automaton zx27
  0x61 => {palette_offset: 2}, # gorgon head -> medusa head
  0x62 => {init_code: 0x02207208, gfx_sheet_ptr_index: 1, palette_offset: 0, palette_list_ptr_index: 1, sprite_ptr_index: 1}, # mad snatcher -> mad butcher
  0x69 => {palette_offset: 9}, # weapon master
  0x6A => {palette_offset: 0xC}, # weapon master
}
BEST_SPRITE_FRAME_FOR_ENEMY = {
  0x07 => 0x24, # nominon
  0x09 => 0x07, # une
  0x0E => 0x08, # invisible man
  0x11 => 0x1E, # demon
  0x15 => 0x10, # forneus
  0x16 => 0x6B, # the creature
  0x17 => 0x03, # black crow
  0x18 => 0x07, # skull spider
  0x1A => 0x1E, # sea demon
  0x1E => 0x1E, # fire demon
  0x24 => 0x5A, # enkidu
  0x29 => 0x10, # skeleton rex
  0x2C => 0x05, # lorelai
  0x31 => 0x0F, # ectoplasm
  0x33 => 0x15, # miss murder
  0x35 => 0x17, # skeleton beast
  0x36 => 0x14, # balloon
  0x3B => 0x1E, # thunder demon
  0x3F => 0x0E, # mandragora
  0x41 => 0x0F, # owl knight
  0x47 => 0x06, # flea man
  0x49 => 0x26, # peeping eye
  0x50 => 0x24, # polkir
  0x54 => 0x14, # gurkha master
  0x55 => 0x14, # red smasher
  0x5B => 0x4A, # rebuild
  0x5D => 0x27, # bugbear
  0x5F => 0x01, # automaton zx27
  0x60 => 0x02, # medusa head
  0x61 => 0x02, # gorgon head
  0x63 => 0x01, # great knight
  0x64 => 0x1D, # king skeleton
  0x66 => 0x01, # final knight
  0x68 => 0x1E, # demon lord
  0x69 => 0x14, # double hammer
  0x6A => 0x14, # weapon master
  0x6B => 0x06, # giant skeleton
  0x6C => 0x03, # arthroverta
  0x6D => 0x40, # brachyura
  0x6E => 0x07, # maneater
  0x70 => 0x4A, # goliath
  0x74 => 0x1D, # wallman
  0x75 => 0x1E, # blackmore
  0x77 => 0x17, # death
  0x78 => 0x38, # dracula
}

ENEMY_FILES_TO_LOAD_LIST = 0x020F2814

SPECIAL_OBJECT_IDS = (0..0x8C)
SPECIAL_OBJECT_CREATE_CODE_LIST = 0x020F370C
SPECIAL_OBJECT_UPDATE_CODE_LIST = 0x020F3940
OVERLAY_FILE_FOR_SPECIAL_OBJECT = {
  0x25 => 62,
  0x27 => 51,
  0x28 => 53,
  0x2F => 53,
  0x38 => 46,
  0x3A => 46,
  0x3B => 55,
  0x3D => 69,
  0x40 => 78,
  0x43 => 65,
  0x44 => 68,
  0x45 => 55,
  0x47 => 57,
  0x48 => 57,
  0x49 => 57,
  0x4A => 57,
  0x4C => 52,
  0x4E => 42,
  0x4F => 63,
  0x50 => 76,
  0x51 => 77,
  0x53 => 72,
  0x54 => 60,
  0x57 => 72,
  0x58 => 41,
  0x59 => 66,
  0x5A => 46,
  0x5B => 46,
  0x5D => 84,
  0x60 => 42,
  0x66 => 78,
}
REUSED_SPECIAL_OBJECT_INFO = {
  0x00 => {init_code:         -1},
  0x01 => {sprite: 0x020C4E24, gfx_files: [0x020B8788, 0x020B8794, 0x020B87A0, 0x020B87AC, 0x020B87B8, 0x020B87D0, 0x020B8818, 0x020B8824], palette: 0x020C8E50}, # magnes point
  0x02 => {init_code: 0x022B6E98}, # destructible
  0x03 => {init_code:         -1},
  0x16 => {init_code: 0x0221A408, palette_offset: 1}, # red chest
  0x17 => {init_code: 0x0221A408, palette_offset: 2}, # blue chest
  0x1A => {init_code:         -1},
  0x1B => {init_code:         -1},
  0x1C => {init_code:         -1},
  0x22 => {init_code:         -1}, # movement slowing area
  0x24 => {init_code:         -1}, # timed boss door opener
  0x2A => {init_code:         -1}, # moving platform waypoint
  0x2E => {sprite: 0x020C4E24, gfx_files: [0x020B8788, 0x020B8794, 0x020B87A0, 0x020B87AC, 0x020B87B8, 0x020B87D0, 0x020B8818, 0x020B8824], palette: 0x020C8E50}, # wooden door
  0x35 => {init_code:         -1},
  0x36 => {init_code:         -1}, # transition room hider TODO
  0x3E => {init_code:         -1},
  0x4B => {sprite: 0x020C4E24, gfx_files: [0x020B8788, 0x020B8794, 0x020B87A0, 0x020B87AC, 0x020B87B8, 0x020B87D0, 0x020B8818, 0x020B8824], palette: 0x020C8E50}, # boss door
  0x55 => {sprite: 0x021DCAC0, gfx_files: [0x020B838C, 0x020B8398, 0x020B83A4, 0x020B83B0, 0x020B83BC, 0x020B83C8, 0x020B83D4, 0x020B83E0, 0x020B83EC, 0x020B83F8, 0x020B8404, 0x020B8410, 0x020B841C, 0x020B8428], palette: 0x020D73D0}, # area titles
  0x5C => {sprite: 0x021DCD34, gfx_files: [0x020BA300], palette: 0x020D151C}, # breakable wall
  0x62 => {init_code:         -1},
  0x63 => {init_code:         -1},
  0x64 => {init_code:         -1},
  0x65 => {init_code:         -1},
  0x67 => {init_code:         -1},
  0x68 => {init_code:         -1},
  0x69 => {init_code:         -1},
  0x6A => {init_code:         -1},
  0x6B => {init_code:         -1},
  0x6C => {init_code:         -1},
  0x6D => {init_code:         -1},
  0x6E => {init_code:         -1},
  0x6F => {init_code:         -1},
  0x70 => {init_code:         -1},
  0x71 => {init_code:         -1},
  0x72 => {init_code:         -1},
  0x73 => {init_code:         -1},
  0x74 => {init_code:         -1},
  0x75 => {init_code:         -1},
  0x76 => {init_code:         -1},
  0x77 => {init_code:         -1},
  0x78 => {init_code:         -1},
  0x79 => {init_code:         -1},
  0x7A => {init_code:         -1},
  0x7B => {init_code:         -1},
  0x7C => {init_code:         -1},
  0x7D => {init_code:         -1},
  0x7E => {init_code:         -1},
  0x7F => {init_code:         -1},
  0x80 => {init_code:         -1},
  0x81 => {init_code:         -1},
  0x82 => {init_code:         -1},
  0x83 => {init_code:         -1},
  0x84 => {init_code:         -1},
  0x85 => {init_code:         -1},
  0x86 => {init_code:         -1},
  0x88 => {init_code:         -1},
  0x89 => {init_code:         -1},
  0x8A => {init_code:         -1},
  0x8B => {init_code:         -1},
  0x8C => {init_code:         -1},
}
BEST_SPRITE_FRAME_FOR_SPECIAL_OBJECT = {
  0x01 => 0x153,
  0x16 => 0x05,
  0x17 => 0x05,
  0x1D =>   -1,
  0x25 => 0x02,
  0x28 => 0x06,
  0x2B =>   -1,
  0x2E => 0xED,
  0x3D =>   -1,
  0x42 => 0x02,
  0x4B => 0xDF,
  0x4E => 0x09,
  0x57 =>   -1,
  0x58 =>   -1,
  0x59 => 0x01,
  0x5B => 0x02,
  0x60 => 0x06,
  0x61 =>   -1,
  0x66 =>   -1,
  0x87 =>   -1,
}
SPECIAL_OBJECT_FILES_TO_LOAD_LIST = 0x020F343C

WEAPON_GFX_LIST_START = 0x020F3BC0
SKILL_GFX_LIST_START = nil

OTHER_SPRITES = [
  {desc: "Common", sprite: 0x020C4E24, gfx_files: [0x020B8788, 0x020B8794, 0x020B87A0, 0x020B87AC, 0x020B87B8, 0x020B87D0, 0x020B8818, 0x020B8824], palette: 0x020C8E50},
  {desc: "Explosion", sprite: 0x021DD02C, gfx_files: [0x020B8830], palette: 0x020C8E50},
  
  {pointer: 0x020EED5C, desc: "Shanoa player"},
  {pointer: 0x020EEDB8, desc: "Arma Felix player"},
  {pointer: 0x020EEE14, desc: "Arma Chiroptera player"},
  {pointer: 0x020EEE70, desc: "Arma Machina player"},
  {pointer: 0x020EEECC, desc: "Albus player"},
  
  {desc: "Albus event actor", sprite: 0x021DCCC4, palette: 0x020D4F3C, gfx_wrapper: 0x022A5CCC},
  {desc: "Barlowe event actor", sprite: 0x021DCCC0, palette: 0x020D4F60, gfx_wrapper: 0x022A5CD4},
  {desc: "Nikolai event actor", sprite: 0x021DCCBC, palette: 0x020D4FC4, gfx_wrapper: 0x022A5CE4},
  {desc: "Jacob event actor", sprite: 0x021DCCB8, palette: 0x020D4FE8, gfx_wrapper: 0x022A5CF4},
  {desc: "Abram event actor", sprite: 0x021DCCB4, palette: 0x020D500C, gfx_wrapper: 0x022A5D0C},
  {desc: "Laura event actor", sprite: 0x021DCCB0, palette: 0x020D5030, gfx_wrapper: 0x022A5D14},
  {desc: "Eugen event actor", sprite: 0x021DCCAC, palette: 0x020D5054, gfx_wrapper: 0x022A5D24},
  {desc: "Aeon event actor", sprite: 0x021DCCA8, palette: 0x020D5078, gfx_wrapper: 0x022A5CB4},
  {desc: "Marcel event actor", sprite: 0x021DCCA4, palette: 0x020D509C, gfx_wrapper: 0x022A5CC4},
  {desc: "George event actor", sprite: 0x021DCCA0, palette: 0x020D50C0, gfx_wrapper: 0x022A5CDC},
  {desc: "Serge event actor", sprite: 0x021DCC9C, palette: 0x020D50E4, gfx_wrapper: 0x022A5CFC},
  {desc: "Anna event actor", sprite: 0x021DCC98, palette: 0x020D5108, gfx_wrapper: 0x022A5D1C},
  {desc: "Monica event actor", sprite: 0x021DCC94, palette: 0x020D512C, gfx_wrapper: 0x022A5CBC},
  {desc: "Irina event actor", sprite: 0x021DCC90, palette: 0x020D5150, gfx_wrapper: 0x022A5CEC},
  {desc: "Daniela event actor", sprite: 0x021DCC8C, palette: 0x020D5174, gfx_wrapper: 0x022A5D2C},
  {desc: "Dracula event actor", sprite: 0x021DCAC8, palette: 0x022CEA40, gfx_wrapper: 0x022A5D04, overlay: 75},
  
  {pointer: 0x022B6DA8, desc: "Glyph statue"},
  {pointer: 0x022B6DBC, desc: "Destructibles 0"},
  {pointer: 0x022B6DD0, desc: "Destructibles 1"},
  {pointer: 0x022B6DE4, desc: "Destructibles 2"},
  {pointer: 0x022B6DF8, desc: "Destructibles 3"},
  {pointer: 0x022B6E0C, desc: "Destructibles 4"},
  {pointer: 0x022B6E20, desc: "Destructibles 5"},
  {pointer: 0x022B6E34, desc: "Destructibles 6"},
  {pointer: 0x022B6E48, desc: "Destructibles 7"},
  {pointer: 0x022B6E5C, desc: "Destructibles 8"},
  {pointer: 0x022B6E70, desc: "Destructibles 9"},
  {pointer: 0x022B6E84, desc: "Destructibles 10"},
  {pointer: 0x022B6E98, desc: "Destructibles 11"},
  {pointer: 0x022B6EAC, desc: "Destructibles 12"},
  
  {desc: "Breakable walls 0", sprite: 0x021DCD4C, gfx_files: [0x020BA2B8], palette: 0x020D0F44},
  {desc: "Breakable walls 1", sprite: 0x021DCD48, gfx_files: [0x020BA2C4], palette: 0x020D10C8},
  {desc: "Breakable walls 2", sprite: 0x021DCD44, gfx_files: [0x020BA2D0], palette: 0x020D120C},
  {desc: "Breakable walls 3", sprite: 0x021DCD40, gfx_files: [0x020BA2DC], palette: 0x020D1270},
  {desc: "Breakable walls 4", sprite: 0x021DCD40, gfx_files: [0x020BA2DC], palette: 0x020D1270},
  {desc: "Breakable walls 5", sprite: 0x021DCD3C, gfx_files: [0x020BA2E8], palette: 0x020D13D4},
  {desc: "Breakable walls 6", sprite: 0x021DCD3C, gfx_files: [0x020BA2E8], palette: 0x020D13D4},
  {desc: "Breakable walls 7", sprite: 0x021DCD38, gfx_files: [0x020BA2F4], palette: 0x020D1458},
  {desc: "Breakable walls 8", sprite: 0x021DCD34, gfx_files: [0x020BA300], palette: 0x020D151C},
]

OVERLAY_FILES_WITH_SPRITE_DATA = []

TEXT_LIST_START_OFFSET = 0x021FACC0 # 0x021FE000 for French text.
TEXT_RANGE = (0..0x764)
TEXT_REGIONS = {
  "Character Names" => (0..0x15),
  "Item Names" => (0x16..0x177),
  "Item Descriptions" => (0x178..0x2D9),
  "Enemy Names" => (0x2DA..0x352),
  "Enemy Descriptions" => (0x353..0x3CB),
  "Misc" => (0x3CC..0x407),
  "Menus" => (0x408..0x65F),
  "Events" => (0x660..0x764)
}
TEXT_REGIONS_OVERLAYS = {
  # French text uses overlay 1 instead of 0.
  "Character Names" => 0,
  "Item Names" => 0,
  "Item Descriptions" => 0,
  "Enemy Names" => 0,
  "Enemy Descriptions" => 0,
  "Misc" => 0,
  "Menus" => 0,
  "Events" => 0
}
STRING_DATABASE_START_OFFSET = 0x021DD280
STRING_DATABASE_ORIGINAL_END_OFFSET = 0x021FACBC
STRING_DATABASE_ALLOWABLE_END_OFFSET = 0x021FFDA0

NAMES_FOR_UNNAMED_SKILLS = {
  0x33 => "Cat Tackle",
  0x34 => "Cat Tail",
  0x35 => "Bat Throw",
  0x36 => "Bat Kick",
}

NEW_GAME_STARTING_AREA_INDEX_OFFSET = 0x020AC14C
NEW_GAME_STARTING_SECTOR_INDEX_OFFSET = 0x020AC154
NEW_GAME_STARTING_ROOM_INDEX_OFFSET = 0x020AC15C

NEW_GAME_STARTING_TOP_SCREEN_TYPE_OFFSET = 0x02214F68

TRANSITION_ROOM_LIST_POINTER = nil
FAKE_TRANSITION_ROOMS = [0x022AE3A8, 0x022A7E78]

ITEM_ICONS_PALETTE_POINTER = 0x020D177C
GLYPH_ICONS_PALETTE_POINTER = 0x020C9854
EXTRACT_ICON_INDEX_AND_PALETTE_INDEX = Proc.new do |icon_data|
  icon_index    = (icon_data & 0b00000111_11111111)
  palette_index = (icon_data & 0b11111000_00000000) >> 11
  [icon_index, palette_index]
end
PACK_ICON_INDEX_AND_PALETTE_INDEX = Proc.new do |icon_index, palette_index|
  icon_data  = icon_index
  icon_data |= palette_index << 11
  icon_data
end

armor_format = [
  # length: 20
  [2, "Item ID"],
  [2, "Icon"],
  [4, "Price"],
  [1, "Type"],
  [1, "Unknown 1"],
  [1, "Defense"],
  [1, "Strength"],
  [1, "Constitution"],
  [1, "Intelligence"],
  [1, "Mind"],
  [1, "Luck"],
  [2, "Resistances", :bitfield],
  [1, "Unknown 2"],
  [1, "Unknown 3"],
]
ITEM_TYPES = [
  {
    name: "Arm Glyphs",
    list_pointer: 0x020F0A08,
    count: 55,
    format: [
      # length: 32
      [2, "Item ID"],
      [2, "Attack"],
      [4, "Code Pointer"],
      [1, "Sprite"],
      [1, "Unknown 1"],
      [1, "Unknown 2"],
      [1, "Mana"],
      [4, "Effects", :bitfield],
      [4, "Unwanted States"],
      [2, "Icon"],
      [1, "Unknown 4"],
      [1, "Unknown 5"],
      [1, "Unknown 6"],
      [1, "Unknown 7"],
      [1, "Unknown 8"],
      [1, "Delay"],
      [1, "Swing Sound"],
      [1, "Unknown 9"],
      [1, "Unknown 10"],
      [1, "Unknown 11"],
    ]
  },
  {
    name: "Back Glyphs",
    list_pointer: 0x020EF8CC,
    count: 25,
    format: [
      # length: 28
      [2, "Item ID"],
      [2, "Unknown 1"],
      [4, "Code Pointer"],
      [1, "Sprite"],
      [1, "Unknown 2"],
      [1, "Unknown 3"],
      [1, "Mana"],
      [4, "Effects", :bitfield],
      [4, "Unwanted States"],
      [2, "Icon"],
      [2, "Var A"],
      [1, "Unknown 5"],
      [1, "Unknown 6"],
      [1, "Unknown 7"],
      [1, "Unknown 8"],
    ]
  },
  {
    name: "Glyph Unions",
    list_pointer: 0x020F0164,
    count: 31,
    format: [
      # length: 28
      [2, "Item ID"],
      [2, "Attack"],
      [4, "Code Pointer"],
      [1, "Sprite"],
      [1, "Unknown 1"],
      [1, "Unknown 2"],
      [1, "Mana"],
      [4, "Effects", :bitfield],
      [4, "Unwanted States"],
      [2, "Icon"],
      [1, "Unknown 4"],
      [1, "Unknown 5"],
      [1, "Unknown 6"],
      [1, "Unknown 7"],
      [1, "Unknown 8"],
      [1, "Unknown 9"],
    ]
  },
  {
    name: "Relics",
    list_pointer: 0x020EF4C4,
    count: 6,
    format: [
      # length: 12
      [2, "Item ID"],
      [2, "Icon"],
      [4, "Unknown 1"],
      [4, "Unknown 2"],
    ]
  },
  {
    name: "Consumables",
    list_pointer: 0x020F04C8,
    count: 112,
    format: [
      # length: 12
      [2, "Item ID"],
      [2, "Icon"],
      [4, "Price"],
      [1, "Type"],
      [1, "Unknown 1"],
      [2, "Var A"],
    ]
  },
  {
    name: "Body Armor",
    list_pointer: 0x020EF6B0,
    count: 27,
    format: armor_format # length: 20
  },
  {
    name: "Head Armor",
    list_pointer: 0x020EFB88,
    count: 36,
    format: armor_format # length: 20
  },
  {
    name: "Leg Armor",
    list_pointer: 0x020EF50C,
    count: 21,
    format: armor_format # length: 20
  },
  {
    name: "Accessories",
    list_pointer: 0x020EFE58,
    count: 39,
    format: armor_format # length: 20
  },
  {
    name: "Weapons (Unused)",
    list_pointer: 0x020EF48C,
    count: 2,
    format: [
      # length: 28
      [2, "Item ID"],
      [2, "Icon"],
      [4, "Price"],
      [1, "Unknown 1"],
      [1, "Attack"],
      [1, "Defense"],
      [1, "Strength"],
      [1, "Constitution"],
      [1, "Intelligence"],
      [1, "Mind"],
      [1, "Luck"],
      [2, "Effects", :bitfield],
      [1, "Unknown 2"],
      [1, "Unknown 3"],
      [1, "GFX"],
      [1, "Palette"],
      [2, "Unknown 4"],
      [2, "Swing Modifiers", :bitfield],
      [2, "Unknown 5"],
    ]
  },
]

ITEM_BITFIELD_ATTRIBUTES = {
  "Resistances" => [
    "Strike",
    "Slash",
    "Fire",
    "Ice",
    "Lightning",
    "Holy",
    "Dark",
    "Resistance 8",
    "Poison",
    "Curse",
    "Stone",
    "Resistance 12",
    "Resistance 13",
    "Resistance 14",
    "Resistance 15",
    "Resistance 16",
  ],
  "Effects" => [
    "Strike",
    "Slash",
    "Fire",
    "Ice",
    "Lightning",
    "Holy",
    "Dark",
    "Effect 8",
    "Poison",
    "Curse",
    "Stone",
    "Torpor",
    "Effect 13",
    "Effect 14",
    "Effect 15",
    "Effect 16",
  ],
  "Swing Modifiers" => [
    "No interrupt on land",
    "Weapon floats in place",
    "Modifier 3",
    "Player can move",
    "Modifier 5",
    "Modifier 6",
    "Transparent weapon",
    "Shaky weapon",
    "No interrupt on anim end",
    "Modifier 10",
    "Modifier 11",
    "Modifier 12",
    "Modifier 13",
    "Modifier 14",
    "Modifier 15",
    "Modifier 16",
  ],
}

ITEM_POOLS_LIST_POINTER = 0x02223B20
ITEM_POOL_INDEXES_FOR_AREAS_LIST_POINTER = 0x02223B08
NUMBER_OF_ITEM_POOLS = 0xB
