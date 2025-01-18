extends Node2D
class_name CaveManager

@onready var floor_layer: TileMapLayer = $"../FloorLayer"
@onready var ground_layer: TileMapLayer = $"../GroundLayer"
@onready var grass_layer: TileMapLayer = $"../GrassLayer"
@onready var object_layer: TileMapLayer = $"../ObjectLayer"
@onready var world: ProcWorld = $".."
@onready var player: Player = %Player
@onready var cave_floor_layer: TileMapLayer = $FloorLayer
@onready var cave_walls_layer: TileMapLayer = $WallsLayer
@onready var noise_generator: NoiseGenerator = %NoiseGenerator
@onready var walker_generator: WalkerGenerator = $WalkerGenerator

var caves: Dictionary = {}
var current_cave: Vector2i ## position of the cave's entrance

func enter():
	var pos = player.position
	position = pos
	var cell_pos = floor_layer.local_to_map(pos)
	current_cave = cell_pos
	var chunk_pos = noise_generator.map_to_chunk(cell_pos)
	world.visible = false
	world.process_mode = Node.PROCESS_MODE_DISABLED
	world.object_layer.collision_enabled = false
	if caves.has(chunk_pos):
		var cave: Dictionary = caves[chunk_pos]
		cave_floor_layer.tile_map_data = cave.get("floor")
		cave_walls_layer.tile_map_data = cave.get("walls")
	else:
		walker_generator.generate()
		_generate_objects()
		caves[chunk_pos] = {
			"floor": cave_floor_layer.tile_map_data,
			"walls": cave_walls_layer.tile_map_data
		}
	visible = true
	player.reparent(self)
	player.move_local_x(16)
	player.move_local_y(18)

func leave():
	position = Vector2.ZERO
	world.visible = true
	world.process_mode = Node.PROCESS_MODE_INHERIT
	world.object_layer.collision_enabled = true
	#reparent(world)
	visible = false
	player.reparent(world)
	player.position = floor_layer.map_to_local(current_cave)
	cave_walls_layer.clear()

func is_valid_entry(pos: Vector2):
	var cell_pos = floor_layer.local_to_map(pos)
	return floor_layer.get_cell_source_id(cell_pos) == 1
func is_valid_exit(pos: Vector2):
	var cell_pos = cave_floor_layer.local_to_map(pos)
	return cave_floor_layer.get_cell_atlas_coords(cell_pos) == Vector2i(7,2) # this is the exit floor tile

func dig() -> bool:
	if has_node("Player"):
		return false
	var mouse_pos = get_local_mouse_position()
	var cell_pos = floor_layer.local_to_map(mouse_pos)
	if ground_layer.get_cell_source_id(cell_pos) and grass_layer.get_cell_source_id(cell_pos):
		return false
	
	var chunk_d: Dictionary = world.get_chunk_data(cell_pos, 1)
	if floor_layer.get_cell_source_id(cell_pos) == -1:
		floor_layer.set_cell(cell_pos,1,Vector2i.ZERO)
		chunk_d[cell_pos] = {
			"type": ProcWorld.ObjType.MANMADE,
			"source": 1,
			"atlas_coords": Vector2i.ZERO,
			"alt_tile": 0
			}
	elif floor_layer.get_cell_source_id(cell_pos) == 1:
		floor_layer.erase_cell(cell_pos)
	return true

func _generate_objects():
	var objects = {
		1: 0.5, # coal ore
		2: 1.2, # iron ore
	}
	var total_weight = 0
	for weight in objects.values():
		total_weight += weight

	for tile_pos: Vector2i in cave_floor_layer.get_used_cells():
		randomize()
		if randf() <= 0.05:
			var random_weight = randf() * total_weight
			var chosen_id = 0
			for tile_id in objects.keys():
				if random_weight <= objects[tile_id]:
					chosen_id = tile_id
					break
			cave_walls_layer.set_cell(tile_pos,1,Vector2i.ZERO,chosen_id)

func delete_object_at(_pos: Vector2i):
	var chunk_pos = noise_generator.map_to_chunk(current_cave)
	var cave = caves.get(chunk_pos, {})
	cave["walls"] = cave_walls_layer.tile_map_data
func get_cave_global_position():
	return floor_layer.map_to_local(current_cave)
