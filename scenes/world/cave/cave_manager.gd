extends Node2D
class_name CaveManager

@onready var floor_layer: TileMapLayer = $"../FloorLayer"
@onready var ground_layer: TileMapLayer = $"../GroundLayer"
@onready var grass_layer: TileMapLayer = $"../GrassLayer"
@onready var object_layer: TileMapLayer = $"../ObjectLayer"

var caves: Dictionary = {}

func enter(pos: Vector2):
	var cell_pos = floor_layer.local_to_map(pos)
	var cave = caves.get_or_add(cell_pos, Cave.new())
	if cave is Cave:
		cave.position = pos
		cave.walker_generator._walked_tiles
		add_child(cave)

func is_valid_entry(pos: Vector2):
	var cell_pos = floor_layer.local_to_map(pos)
	return floor_layer.get_cell_source_id(cell_pos) == 1

func dig():
	var mouse_pos = get_local_mouse_position()
	var cell_pos = floor_layer.local_to_map(mouse_pos)
	if ground_layer.get_cell_source_id(cell_pos) and grass_layer.get_cell_source_id(cell_pos):
		return
	if floor_layer.get_cell_source_id(cell_pos) == -1:
		floor_layer.set_cell(cell_pos,1,Vector2i.ZERO)
	else:
		floor_layer.erase_cell(cell_pos)
