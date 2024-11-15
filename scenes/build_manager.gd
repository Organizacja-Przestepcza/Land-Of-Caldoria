extends Node2D
class_name BuildManager

@onready var build_layer: TileMapLayer = $"../BuildLayer"

func build():
	print("Hammer time")
	var mouse_pos = get_local_mouse_position()
	var cell_pos = build_layer.local_to_map(mouse_pos)
	print(cell_pos)
	build_layer.set_cell(cell_pos,0,Vector2i(9,14))
