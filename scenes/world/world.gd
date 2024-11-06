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

var mob_amount: int = 0

var dirs: Dictionary = {"tree":"res://scenes/object/plant/tree/","stone":"res://scenes/object/ore/stone/"}
var files: Dictionary = {"tree":DirAccess.get_files_at(dirs["tree"]), "stone": DirAccess.get_files_at(dirs["stone"])}

@onready var water_layer = $WaterLayer
@onready var sand_layer = $SandLayer
@onready var ground_layer = $GroundLayer
@onready var grass_layer = $GrassLayer

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
	if WorldData.load:
		$Player/Hud.load_inventory_data()
		$Player.global_position = WorldData.load.player_global_position
	Engine.time_scale = 1
	
func generate_world() -> void:
	var map_size: int = WorldData.size
	var map_range: Array = range(-map_size/2, map_size/2)
	for x in map_range:
		for y in map_range:
			var h_noise_val: float = h_noise.get_noise_2d(x, y)
			var o_noise_val: float = o_noise.get_noise_2d(x, y)
			water_layer.set_cell(Vector2i(x,y), source_water,Vector2i(0,0))
			if h_noise_val > -0.1:
				tiles_sand.append(Vector2i(x,y))
			if h_noise_val > -0.05:
				tiles_ground.append(Vector2i(x,y))
			if h_noise_val > 0.05:
				tiles_grass.append(Vector2i(x,y))
				
			# Objects
			var pos = Vector2i((x*32)+16,(y*32)+16)
			if h_noise_val > 0.1 and o_noise_val > 0 and y % randi_range(2,5) == x % randi_range(2,5):
				generate_object("tree",pos)
			if h_noise_val > -0.05 and o_noise_val < -0.1 and y % randi_range(2,5) == x % randi_range(2,5):
				generate_object("stone",pos)
			if h_noise_val > 0.12 and o_noise_val < 0 and o_noise_val > -0.1 and y % randi_range(2,5) == x % randi_range(2,5):
				var bush = load("res://scenes/object/plant/bush/bush_blueberry.tscn").instantiate()
				bush.global_position = pos
				self.add_child(bush)
			if h_noise_val > 0.03:
				chance_spawn_mob(pos)
	sand_layer.set_cells_terrain_connect(tiles_sand, 0, terrain_sand)
	ground_layer.set_cells_terrain_connect(tiles_ground, 0, terrain_ground)
	grass_layer.set_cells_terrain_connect(tiles_grass, 0, terrain_grass)
	
func generate_object(obj_name: String, pos: Vector2i) -> void:
	var f = files[obj_name] # takes the file array for given object
	var rand_obj = f[randi_range(0,f.size()-1)]
	var obj = load(dirs[obj_name] + rand_obj).instantiate()
	obj.global_position = pos
	self.add_child(obj)
	
func chance_spawn_mob(pos: Vector2i) -> void:
	if mob_amount <= 4 and randi_range(0, 100) == 1:
		var slime = load("res://scenes/mob/slime.tscn").instantiate()
		slime.global_position = pos
		add_child(slime)
		mob_amount+=1
