extends Node2D
class_name ProcWorld

@onready var water_layer: TileMapLayer = $WaterLayer
@onready var sand_layer: TileMapLayer = $SandLayer
@onready var ground_layer: TileMapLayer = $GroundLayer
@onready var grass_layer: TileMapLayer = $GrassLayer
@onready var object_layer: TileMapLayer = $ObjectLayer

@onready var noise_generator: NoiseGenerator = $NoiseGenerator
@onready var player: Player = %Player
var h_noise: FastNoiseLite # height noise
var user_seed = WorldData.seed

func _ready() -> void:
	if WorldData.size > 0:
		generate_world()
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
			print("loaded chunks:", noise_generator.generated_chunks)
			var chunk = noise_generator.map_to_chunk(noise_generator.global_to_map(player.position))
			print("player is in: ", chunk, "  is loaded? ", noise_generator.has_chunk(chunk))
			print("---")

func _on_rendered(chunk_position: Vector2i) -> void:
	$LoadingScreen.visible = false

func generate_world() -> void:
	h_noise = FastNoiseLite.new()
	if user_seed == -1:
		h_noise.seed = randi()
		WorldData.seed = h_noise.seed
	else:
		print("User seed: " + str(user_seed))
		h_noise.seed = user_seed
	h_noise.frequency = 0.0075
	player.position = Vector2i(0,0)
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
			
			#if h_noise_val > 0.03:
				#chance_spawn_mob(pos)
	BetterTerrain.set_cells(sand_layer,sand_cells,2)
	BetterTerrain.set_cells(ground_layer,ground_cells,3)
	BetterTerrain.set_cells(grass_layer,grass_cells,1)
	BetterTerrain.update_terrain_cells(sand_layer,sand_cells)
	BetterTerrain.update_terrain_cells(grass_layer,grass_cells)
	BetterTerrain.update_terrain_cells(ground_layer,ground_cells)
	
