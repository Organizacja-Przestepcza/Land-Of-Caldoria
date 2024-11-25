extends Node2D
class_name ProcWorld

@onready var water_layer: TileMapLayer = $WaterLayer
@onready var sand_layer: TileMapLayer = $SandLayer
@onready var ground_layer: TileMapLayer = $GroundLayer
@onready var grass_layer: TileMapLayer = $GrassLayer
@onready var object_layer: TileMapLayer = $ObjectLayer

@onready var noise_generator: NoiseGenerator = $NoiseGenerator
@onready var terrain_renderer: BetterTerrainGaeaRenderer = $NoiseGenerator/BetterTerrainGaeaRenderer
@onready var player: Player = %Player
var h_noise: FastNoiseLite # height noise
var user_seed = WorldData.seed

func _ready() -> void:
	if WorldData.size > 0:
		player.position = Vector2i(0,0)
		generate_finite_world()
	else:
		noise_generator.set_seed(user_seed)
		var chunk_loader: ThreadedChunkLoader2D = ThreadedChunkLoader2D.new()
		chunk_loader.actor = player
		chunk_loader.generator = noise_generator
		noise_generator.add_child(chunk_loader)
	get_tree().paused = false

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_BACKSPACE and event.echo == false and event.pressed == true:
			var chunk = noise_generator.map_to_chunk(noise_generator.global_to_map(player.position))
			print("player is in: ", chunk)
			print("---")

func _on_rendered(chunk_position: Vector2i) -> void:
	$LoadingScreen.visible = false

func generate_finite_world() -> void:
	h_noise = FastNoiseLite.new()
	if user_seed == -1:
		h_noise.seed = randi()
		WorldData.seed = h_noise.seed
	else:
		print("User seed: " + str(user_seed))
		h_noise.seed = user_seed
	h_noise.frequency = 0.0075
	var map_size: int = WorldData.size
	var map_range: Array = range(-map_size/2, map_size/2)
	var grass_cells: PackedVector2Array
	var ground_cells: PackedVector2Array
	var sand_cells: PackedVector2Array
	for x in map_range:
		for y in map_range:
			var h_noise_val: float = h_noise.get_noise_2d(x, y)
			water_layer.set_cell(Vector2i(x,y), 1,Vector2i(0,0))
			if h_noise_val > 0.05:
				grass_cells.append(Vector2i(x,y))
			if h_noise_val > -0.05:
				ground_cells.append(Vector2i(x,y))
			if h_noise_val > -0.1:
				sand_cells.append(Vector2i(x,y))
				
			# Objects
			if h_noise_val > 0.1 and y % randi_range(2,5) == x % randi_range(2,5):
				object_layer.set_cell(Vector2i(x,y), 2, Vector2i(0, 0), randi_range(1,7))
			if h_noise_val > -0.05 and y % randi_range(2,5) == x % randi_range(2,5):
				object_layer.set_cell(Vector2i(x,y), 4, Vector2i(0, 0), 1)
			
			if h_noise_val > 0.03:
				chance_spawn_mob(Vector2i(32*x+16,32*y+16))
	BetterTerrain.set_cells(sand_layer,sand_cells,2)
	BetterTerrain.set_cells(ground_layer,ground_cells,3)
	BetterTerrain.set_cells(grass_layer,grass_cells,1)
	BetterTerrain.update_terrain_cells(sand_layer,sand_cells)
	BetterTerrain.update_terrain_cells(grass_layer,grass_cells)
	BetterTerrain.update_terrain_cells(ground_layer,ground_cells)
	
#func generate_objects():
	#var pos = Vector2i((x*32)+16,(y*32)+16)
	#if h_noise_val > 0.1 and o_noise_val > 0 and y % randi_range(2,5) == x % randi_range(2,5):
		#build_layer.set_cell(Vector2i(x,y), 2, Vector2i(0, 0), randi_range(1,7))
	#if h_noise_val > -0.05 and o_noise_val < -0.1 and y % randi_range(2,5) == x % randi_range(2,5):
		#build_layer.set_cell(Vector2i(x,y), 4, Vector2i(0, 0), 1)
	#if h_noise_val > 0.12 and o_noise_val < 0 and o_noise_val > -0.1 and y % randi_range(2,5) == x % randi_range(2,5):
		#var bush = load("res://scenes/object/plant/bush/bush_blueberry.tscn").instantiate()
		#bush.global_position = pos
		#self.add_child(bush)
	#if h_noise_val > 0.03:
		#chance_spawn_mob(pos)
#

var mob_types = {
	"slime": preload("res://scenes/mob/slime.tscn"),
	"crab": preload("res://scenes/mob/crab.tscn"),
	"boar": preload("res://scenes/mob/boar.tscn"),
}

func chance_spawn_mob(pos: Vector2) -> void:
	print(pos)
	if randi_range(0, 100) <= 3:
		var mob_name = choose_random_mob()
		var mob = mob_types[mob_name].instantiate()
		mob.global_position = pos
		add_child(mob)

func choose_random_mob() -> String:
	var mob_list = mob_types.keys()
	var random_index = randi() % mob_list.size()
	return mob_list[random_index]

func _on_chunk_erased(chunk_position: Vector2i) -> void:
	pass # Replace with function body.


func _on_chunk_rendered(chunk_position: Vector2i) -> void:
	var pos: Vector2i = chunk_to_global(chunk_position)
	for chunk in range(noise_generator.chunk_size.x):
		var x = pos.x + 32 * chunk
		var y = pos.y + 32 * chunk
		var mob_pos = Vector2i(x,y)
		if not ground_layer.get_cell_source_id(pos) == -1:
			#print(mob_pos)
			chance_spawn_mob(mob_pos)
			
func chunk_to_global(chunk_pos: Vector2i) -> Vector2i:
	var pos = chunk_pos*noise_generator.chunk_size*noise_generator.tile_size
	return pos


func _on_chunk_generation_finished(chunk_position: Vector2i) -> void:

	print(chunk_position)
