extends Node2D
class_name ProcWorld

var h_noise: FastNoiseLite # height noise



# Arrays
var tiles_grass: Array  = []
var tiles_ground: Array = []
var tiles_sand: Array   = []
# Terrain ids
var terrain_grass: int  = 0
var terrain_ground: int = 1
var terrain_sand: int   = 2

@onready var water_layer: TileMapLayer = $WaterLayer
@onready var sand_layer: TileMapLayer = $SandLayer
@onready var ground_layer: TileMapLayer = $GroundLayer
@onready var grass_layer: TileMapLayer = $GrassLayer
@onready var build_layer: TileMapLayer = $BuildLayer

func _ready() -> void:
	h_noise = FastNoiseLite.new()
	var user_seed = WorldData.seed
	if user_seed == -1:
		h_noise.seed = randi()
		WorldData.seed = h_noise.seed
	else:
		print("User seed: " + str(user_seed))
		h_noise.seed = user_seed
	h_noise.frequency = 0.0075
	generate_world()
	get_tree().paused = false
	
func generate_world() -> void:
	var map_size: int = WorldData.size
	var map_range: Array = range(-map_size/2, map_size/2)
	for x in map_range:
		for y in map_range:
			var h_noise_val: float = h_noise.get_noise_2d(x, y)
			water_layer.set_cell(Vector2i(x,y), 1,Vector2i(0,0))
			if h_noise_val > 0.05:
				tiles_grass.append(Vector2i(x,y))
			if h_noise_val > -0.05:
				tiles_ground.append(Vector2i(x,y))
			if h_noise_val > -0.1:
				tiles_sand.append(Vector2i(x,y))

	sand_layer.set_cells_terrain_connect(tiles_sand, 0, terrain_sand)
	ground_layer.set_cells_terrain_connect(tiles_ground, 0, terrain_ground)
	grass_layer.set_cells_terrain_connect(tiles_grass, 0, terrain_grass)
