extends Node2D

@export var height_noise: NoiseTexture2D
@export var map_size: int = 256

var noise: Noise
var noise_arr = []
# Tile arrays (for autotiling)
var tiles_grass: Array  = []
var tiles_ground: Array = []
var tiles_sand: Array   = []
# Terrain ids
var terrain_grass: int  = 0
var terrain_ground: int = 1
var terrain_sand: int   = 2
# Tiles texture sources
var source_ground: int = 0
var source_water: int  = 1


@onready var water_layer = $WaterLayer
@onready var sand_layer = $SandLayer
@onready var ground_layer = $GroundLayer
@onready var grass_layer = $GrassLayer

func _ready() -> void:
	noise = height_noise.noise
	generate_world()


func generate_world() -> void:
	var map_range: Array = range(-map_size/2, map_size/2)
	for x in map_range:
		for y in map_range:
			var noise_val: float = noise.get_noise_2d(x, y)
			water_layer.set_cell(Vector2i(x,y), source_water,Vector2i(0,0))
			if noise_val > 0:
				tiles_sand.append(Vector2i(x,y))
			if noise_val > 0.1:
				tiles_ground.append(Vector2i(x,y))
			if noise_val > 0.2:
				tiles_grass.append(Vector2i(x,y))
	sand_layer.set_cells_terrain_connect(tiles_sand, 0, terrain_sand)
	ground_layer.set_cells_terrain_connect(tiles_ground, 0, terrain_ground)
	grass_layer.set_cells_terrain_connect(tiles_grass, 0, terrain_grass)
