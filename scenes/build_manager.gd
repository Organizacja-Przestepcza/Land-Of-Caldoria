extends Node2D
class_name BuildManager

@onready var build_layer: TileMapLayer = $"../BuildLayer"

var walls: Array = []

func build():
	print("Hammer time")
	var mouse_pos = get_local_mouse_position()
	var cell_pos = build_layer.local_to_map(mouse_pos)
	if cell_pos in walls:
		return
	print(cell_pos)
	walls.append(cell_pos)
	build_layer.set_cells_terrain_connect(walls,1,0)
	#build_layer.set_cell(cell_pos,2,Vector2i(9,14))
