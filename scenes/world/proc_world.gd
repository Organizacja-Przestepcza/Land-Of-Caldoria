extends Node2D
class_name ProcWorld

@onready var water_layer: TileMapLayer = $WaterLayer
@onready var sand_layer: TileMapLayer = $SandLayer
@onready var ground_layer: TileMapLayer = $GroundLayer
@onready var grass_layer: TileMapLayer = $GrassLayer
@onready var object_layer: TileMapLayer = $ObjectLayer
@onready var floor_layer: TileMapLayer = $FloorLayer
@onready var biome_decor_layer: TileMapLayer = $BiomeDecorLayer

@onready var noise_generator: NoiseGenerator = $NoiseGenerator
@onready var terrain_renderer: BetterTerrainGaeaRenderer = $NoiseGenerator/ThreadedBetterTerrainGaeaRenderer
@onready var player: Player = %Player
var chunk_loader: ChunkLoader
var user_seed = WorldData.seed
var music_player: EventAudio.AudioEmitter2D

var biome_noise := FastNoiseLite.new()
var biome_salt := 51378

var object_tiles: Dictionary = {}
var floor_tiles: Dictionary = {}
@onready var tile_layer_arr: Array[Dictionary] = [
	{_TILES: object_tiles,_LAYER: object_layer}, 
	{_TILES: floor_tiles,_LAYER: floor_layer}
]
enum {_TILES = 0, _LAYER = 1}
enum ObjType {NATURAL,MANMADE}

func _ready() -> void:
	if user_seed == -1:
		user_seed = randi()
	noise_generator.settings.noise.seed = user_seed
	WorldData.seed = user_seed
	# Biomes setup
	biome_noise.seed = user_seed + biome_salt
	
	# Chunkloader creation
	chunk_loader = ChunkLoader.new()
	chunk_loader.unload_chunks = Settings.unload_chunks
	chunk_loader.loading_radius = Vector2i(1,1)
	chunk_loader.actor = player
	chunk_loader.update_rate = 100
	chunk_loader.generator = noise_generator
	chunk_loader.connect("chunk_changed", _on_chunk_changed)
	# Loading data
	if WorldData.load:
		player.inventory.load_data()
		player.global_position = WorldData.load.player_global_position
		object_tiles = WorldData.load.objects
		floor_tiles = WorldData.load.floors
		$CaveManager.caves = WorldData.load.caves
	noise_generator.add_child(chunk_loader)
	$CaveManager.reparent(get_tree().root)
	get_tree().paused = false
	generate_village()
	music_player = EventAudio.play_2d("overworld_ambient",player)
	update_volume()
	
func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_BACKSPACE and event.echo == false and event.pressed == true:
			var chunk = noise_generator.map_to_chunk(noise_generator.global_to_map(player.position))
			print("---")
			print("Player is in: ", chunk)
			print("Chunk boundaries ",_get_chunk_boundaries(chunk).position, " - ", _get_chunk_boundaries(chunk).end)
			print("---")

#region Objects

func load_objects(chunk_pos: Vector2i):
	for tiles in tile_layer_arr:
		var chunk_d: Dictionary = tiles.get(_TILES, {}).get_or_add(chunk_pos, {})
		for tile_pos: Vector2i in chunk_d.keys():
			var tile_data: Dictionary = chunk_d.get(tile_pos, {})
			tiles[_LAYER].set_cell(tile_pos, tile_data.get("source"), tile_data.get("atlas_coords"), tile_data.get("alt_tile"))

func generate_objects(chunk_pos: Vector2i):
	var pos = _chunk_to_map(chunk_pos)
	for tiles in tile_layer_arr:
		var chunk_d: Dictionary = tiles[0].get(chunk_pos, {})
		for x in range(pos.x,pos.x+noise_generator.chunk_size.x):
			for y in range(pos.y,pos.y+noise_generator.chunk_size.y):
				var h_noise_val: float = noise_generator.settings.noise.get_noise_2d(x,y)
				var tile_pos = Vector2i(x,y)
				if not object_layer.get_cell_source_id(tile_pos) == -1: # if tile is not empty (aka there is an object there) - skip
					continue
				if h_noise_val > 0.1 and y % randi_range(2,5) == x % randi_range(2,5) and randi_range(0,100) < 25 and biome_decor_layer.get_cell_source_id(Vector2i(x,y)) != 4:
					object_layer.set_cell(tile_pos, 0, Vector2i(0, 0), randi_range(1,7))
					chunk_d[tile_pos] = {
						"type": ObjType.NATURAL,
						"source": 0,
						"atlas_coords": Vector2i.ZERO,
						"alt_tile": object_layer.get_cell_alternative_tile(tile_pos) # change to atlas coords if the tile is not from scene collection
					}
				if h_noise_val > -0.05 and y % randi_range(2,5) == x % randi_range(2,5) and randi_range(0,100) < 5:
					object_layer.set_cell(tile_pos, 1, Vector2i(0, 0), randi_range(1,5))
					chunk_d[tile_pos] = {
						"type": ObjType.NATURAL,
						"source": 1,
						"atlas_coords": Vector2i.ZERO,
						"alt_tile": object_layer.get_cell_alternative_tile(tile_pos) # change to atlas coords if the tile is not from scene collection
					}

func unload_objects(chunk_pos: Vector2i):
	for tiles: Dictionary in tile_layer_arr:
		var tiles_in_chunk: Dictionary = tiles.get(_TILES, {}).get_or_add(chunk_pos, {})
		for tile_pos in tiles_in_chunk.keys():
			if not tiles[_LAYER].get_cell_atlas_coords(tile_pos) == Vector2i(-1,-1): # dirty fix for overwriting of saved tiles
				tiles_in_chunk[tile_pos]["atlas_coords"] = tiles[_LAYER].get_cell_atlas_coords(tile_pos)
			tiles[_LAYER].set_cell(tile_pos)

## Saves objects from chunks in loading radius into [member object_tiles] and [member floor_tiles]
func save_loaded_chunks_objects():
	for tiles: Dictionary in tile_layer_arr:
		for chunk_pos in chunk_loader._get_required_chunks(chunk_loader._get_actors_position()):
			var chunk_posi = Vector2i(chunk_pos)
			var tiles_in_chunk: Dictionary = tiles.get(_TILES, {}).get(chunk_posi, {})
			if tiles_in_chunk.is_empty():
				continue
			for tile_pos: Vector2i in tiles_in_chunk.keys():
				tiles_in_chunk[tile_pos]["atlas_coords"] = tiles.get(_LAYER).get_cell_atlas_coords(tile_pos)
#endregion

#region Structures

var active_buildings: Array = []

const building_types = {
	"ruins": preload("res://scenes/meadow_ruins.tscn"),
	"ruins2": preload("res://scenes/meadow_ruins2.tscn")
}

func is_valid_building_position(chunk_pos: Vector2i) -> bool:
	for other_chunk_pos in active_buildings:
		if (chunk_pos.distance_squared_to(other_chunk_pos) < 100):
			return false
	return true
	
func choose_random_building() -> String:
	var building_list = building_types.keys();
	var random_index = randi() % building_list.size()
	return building_list[random_index]
	
func generate_village() -> void:
	var village_scene = preload("res://scenes/village.tscn")
	var village = village_scene.instantiate()
	village.z_index = -1;
	village.position = Vector2(0, 0)
	add_child(village)
	var build: TileMapLayer = village.get_node("Objects")
	var floor: TileMapLayer = village.get_node("Floor")
	# set walls
	BetterTerrain.set_cells(object_layer,build.get_used_cells_by_id(3),0)
	# set fence
	BetterTerrain.set_cells(object_layer,build.get_used_cells_by_id(7),1)
	# set stone floor
	BetterTerrain.set_cells(floor_layer,floor.get_used_cells_by_id(0),0)
	# set path
	BetterTerrain.set_cells(floor_layer,floor.get_used_cells_by_id(2),1)
	# set field
	BetterTerrain.set_cells(floor_layer,floor.get_used_cells_by_id(4),3)
	BetterTerrain.set_cells(floor_layer,floor.get_used_cells_by_id(5),2)
	
	# update layers
	BetterTerrain.update_terrain_cells(object_layer,build.get_used_cells())
	BetterTerrain.update_terrain_cells(floor_layer,floor.get_used_cells())
	
	village.get_node("Objects").clear()
	village.get_node("Floor").clear()
	
func chance_spawn_building(chunk_pos: Vector2i) -> void:
	var tile_pos = _chunk_to_map(chunk_pos)
	var h_noise_val = noise_generator.settings.noise.get_noise_2d(tile_pos.x,tile_pos.y)
	if h_noise_val > -0.03 and randi_range(0, 100) <= 20 and is_valid_building_position(chunk_pos):
		var building_name = choose_random_building()
		var building_scene = building_types[building_name]
		if building_scene:
			print("Spawning at ",chunk_pos)
			unload_objects(chunk_pos)
			var building = building_scene.instantiate()
			building.z_index = -1;
			building.position = _chunk_to_global(chunk_pos)
			add_child(building)
			active_buildings.append(chunk_pos)
				
func generate_buildings_on_chunk(chunk_pos: Vector2i):
	if chunk_pos.x < 3 and chunk_pos.y < 3:
		return
	chance_spawn_building(chunk_pos)
#endregion

#region Mobs

const mob_types: Array[String] = ["slime","crab","boar","bear","wolf","sheep"]

func chance_spawn_mob(pos: Vector2) -> void:
	var tile_pos = ground_layer.local_to_map(pos)
	var h_noise_val: float = noise_generator.settings.noise.get_noise_2d(tile_pos.x,tile_pos.y)
	if h_noise_val > -0.05 and object_layer.get_cell_source_id(tile_pos) == -1: # if there is ground and no objects
		if randi_range(0, 1000) <= 2: # 0.2% chance
			var mob_name = mob_types.pick_random()
			var mob = MobLoader.get_mob(mob_name)
			if mob is Enemy:
				mob.add_to_group("enemies")
			elif mob is Neutral:
				mob.add_to_group("neutrals")
			mob.global_position = pos
			add_child(mob)

func generate_mobs_on_chunk(chunk_position: Vector2i):
	var pos: Vector2i = _chunk_to_global(chunk_position)
	for tile_x in range(noise_generator.chunk_size.x):
		for tile_y in range(noise_generator.chunk_size.y):
			var x = pos.x + noise_generator.tile_size.x * tile_x
			var y = pos.y + noise_generator.tile_size.y * tile_y
			var mob_pos = Vector2i(x,y)
			chance_spawn_mob(mob_pos)
#endregion

#region Signal functions

func _on_chunk_rendered(chunk_position: Vector2i) -> void:
	if (object_tiles.has(chunk_position) or floor_tiles.has(chunk_position)) and chunk_loader._get_required_chunks(chunk_loader._get_actors_position()).has(chunk_position): # if chunk is in loading radius and has objects
		load_objects(chunk_position)
	elif object_tiles.has(chunk_position): # if the chunk has objects, but is NOT in loading radius
		return
	elif chunk_position != Vector2i(0,0) and chunk_position != Vector2i(1,0): # generate new chunk
		if chunk_position.abs() > Vector2i(2,2):
			generate_biomes(chunk_position)
		generate_objects(chunk_position)
		generate_mobs_on_chunk(chunk_position)
		generate_buildings_on_chunk(chunk_position)

		

func _on_chunk_changed(chunk_position: Vector2i): # this function could probably be done better, so it unloads just unloaded chunks
	for chunk in object_tiles.keys(): 
		if not chunk_loader._get_required_chunks(chunk_position).has(chunk): # if chunk is not required
			unload_objects(chunk)
#endregion

#region ChunkHelpers

func delete_object_at(pos: Vector2i, layer: int = 0): ## 0 is object layer, 1 is floor layer
	var chunk = noise_generator.map_to_chunk(pos)
	var tiles: Dictionary = tile_layer_arr[layer].get(_TILES, {})
	if tiles.has(chunk):
		tiles[chunk].erase(pos)

func delete_floor_at(pos: Vector2i):
	var chunk = noise_generator.map_to_chunk(pos)
	if floor_tiles.has(chunk):
		floor_tiles[chunk].erase(pos)

func _chunk_to_global(chunk_pos: Vector2i) -> Vector2i:
	var pos = chunk_pos*noise_generator.chunk_size*noise_generator.tile_size
	return pos

func _chunk_to_map(chunk_pos: Vector2i) -> Vector2i:
	var pos = chunk_pos*noise_generator.chunk_size
	return pos

func _get_chunk_boundaries(chunk_pos: Vector2i) -> Rect2i:
	var start_point = _chunk_to_global(chunk_pos)
	var size: Vector2i
	size.x = noise_generator.chunk_size.x * noise_generator.tile_size.x - 1
	size.y = noise_generator.chunk_size.y * noise_generator.tile_size.y - 1
	return Rect2i(start_point,size)
	
func _chunk_positions_to_tile_positions(chunk_positions: Array) -> Array:
	var tile_positions: Array = []

	for chunk_pos in chunk_positions:
		var chunk_tile_start = chunk_pos * noise_generator.chunk_size  # Top-left tile position in world space
		for x in range(chunk_tile_start.x, chunk_tile_start.x + noise_generator.chunk_size.x):
			for y in range(chunk_tile_start.y, chunk_tile_start.y + noise_generator.chunk_size.y):
				tile_positions.append(Vector2i(x, y))  # Add tile position to the list
	return tile_positions

func get_chunk_data(cell_pos: Vector2i, layer: int = 0): ## 0 is object layer, 1 is floor layer
	var chunk = noise_generator.map_to_chunk(cell_pos)
	var tiles = tile_layer_arr[layer].get(_TILES, {})
	var chunk_d: Dictionary = tiles.get_or_add(chunk, {})
	return chunk_d

func is_only_water(pos: Vector2):
	var cell_pos = grass_layer.local_to_map(pos)
	if grass_layer.get_cell_source_id(cell_pos) != -1:
		return false
	if ground_layer.get_cell_source_id(cell_pos) != -1:
		return false
	if sand_layer.get_cell_source_id(cell_pos) != -1:
		return false
	return true

func is_only_sand(pos: Vector2):
	var cell_pos = grass_layer.local_to_map(pos)
	if grass_layer.get_cell_source_id(cell_pos) != -1:
		return false
	if ground_layer.get_cell_source_id(cell_pos) != -1:
		return false
	if sand_layer.get_cell_source_id(cell_pos) == -1:
		return false
	return true

#endregion

#region Biomes

func generate_biomes(chunk_position: Vector2i):
	var pos = _chunk_to_map(chunk_position)
	var _cell_arr_snow: Array
	var _cell_arr_war: Array
	for x in range(pos.x,pos.x+noise_generator.chunk_size.x):
		for y in range(pos.y,pos.y+noise_generator.chunk_size.y):
			if biome_noise.get_noise_2d(x,y) > 0.2 and noise_generator.settings.noise.get_noise_2d(x,y) > 0.02:
				_cell_arr_snow.append(Vector2i(x,y))
				BetterTerrain.set_cell(biome_decor_layer,Vector2i(x,y),5)
			elif biome_noise.get_noise_2d(x,y) < -0.3 and noise_generator.settings.noise.get_noise_2d(x,y) > 0.04:
				_cell_arr_war.append(Vector2i(x,y))
				BetterTerrain.set_cell(biome_decor_layer,Vector2i(x,y),6)
	BetterTerrain.update_terrain_cells(biome_decor_layer,_cell_arr_snow)
	BetterTerrain.update_terrain_cells(biome_decor_layer,_cell_arr_war)
#endregion

func update_volume():
	if music_player:
		music_player.player.volume_db = Settings.music_volume


func _on_chunk_generation_finished(_chunk_position: Vector2i) -> void:
	pass # Replace with function body.
