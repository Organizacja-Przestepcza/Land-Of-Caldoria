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
	reparent(get_tree().root)
	if caves.has(chunk_pos):
		var cave: Dictionary = caves[chunk_pos]
		cave_floor_layer.tile_map_data = cave.get("floor")
		cave_walls_layer.tile_map_data = cave.get("walls")
	else:
		walker_generator.generate()
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
	#reparent(world)
	visible = false
	player.reparent(world)
	player.move_local_x(-16)
	player.move_local_y(-18)
	player.position = floor_layer.map_to_local(current_cave)
	cave_walls_layer.clear()

func is_valid_entry(pos: Vector2):
	var cell_pos = floor_layer.local_to_map(pos)
	return floor_layer.get_cell_source_id(cell_pos) == 1
func is_valid_exit(pos: Vector2):
	var cell_pos = cave_floor_layer.local_to_map(pos)
	return cave_floor_layer.get_cell_atlas_coords(cell_pos) == Vector2i(7,2) # this is the exit floor tile

func dig():
	if has_node("Player"):
		return
	var mouse_pos = get_local_mouse_position()
	print(mouse_pos)
	var cell_pos = floor_layer.local_to_map(mouse_pos)
	if ground_layer.get_cell_source_id(cell_pos) and grass_layer.get_cell_source_id(cell_pos):
		return
	if floor_layer.get_cell_source_id(cell_pos) == -1:
		floor_layer.set_cell(cell_pos,1,Vector2i.ZERO)
	elif floor_layer.get_cell_source_id(cell_pos) == 1:
		floor_layer.erase_cell(cell_pos)
