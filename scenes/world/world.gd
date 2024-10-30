extends Node2D

var h_noise: FastNoiseLite # height noise
var o_noise: FastNoiseLite # objects noise

# Arrays
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
@onready var trees = $Trees

func _ready() -> void:
	h_noise = FastNoiseLite.new()
	o_noise = FastNoiseLite.new()
	var user_seed = WorldData.seed
	if user_seed == -1:
		h_noise.seed = randi()
	else:
		print("User seed: " + str(user_seed))
		h_noise.seed = user_seed
	o_noise.frequency = 0.02
	h_noise.frequency = 0.0075
	generate_world()


func generate_world() -> void:
	var map_size: int = WorldData.size
	var map_range: Array = range(-map_size/2, map_size/2)
	for x in map_range:
		for y in map_range:
			var h_noise_val: float = h_noise.get_noise_2d(x, y)
			var o_noise_val: float = o_noise.get_noise_2d(x, y)
			water_layer.set_cell(Vector2i(x,y), source_water,Vector2i(0,0))
			if h_noise_val > 0:
				tiles_sand.append(Vector2i(x,y))
			if h_noise_val > 0.1:
				tiles_ground.append(Vector2i(x,y))
			if h_noise_val > 0.2:
				tiles_grass.append(Vector2i(x,y))
				
			# Objects
			if h_noise_val > 0.2 and o_noise_val > 0 and y % randi_range(2,5) == x % randi_range(2,5):
				print("tree")
				var tree = preload("res://scenes/object/plant/tree/tree.tscn").instantiate()
				tree.position = Vector2i((x*32)+16,(y*32)+16)
				trees.add_child(tree)
				pass
	
	sand_layer.set_cells_terrain_connect(tiles_sand, 0, terrain_sand)
	ground_layer.set_cells_terrain_connect(tiles_ground, 0, terrain_ground)
	grass_layer.set_cells_terrain_connect(tiles_grass, 0, terrain_grass)
	


func _on_pause_menu_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/start.tscn")
