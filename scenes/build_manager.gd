extends Node2D
class_name BuildManager

@onready var building_menu: BuildMenu = $"../Player/Interface/Building"
@onready var build_layer: TileMapLayer = $"../BuildLayer"

var walls: Array = []

func build():
	print("Hammer time")
	var mouse_pos = get_local_mouse_position()
	var cell_pos = build_layer.local_to_map(mouse_pos)
	if building_menu.selected_item == 0:
		if cell_pos in walls:
			var index = walls.find(cell_pos)
			print(index)
			walls.remove_at(index)
			build_layer.set_cell(cell_pos)
	elif building_menu.selected_item == 1:
		if cell_pos in walls:
			return
		print(cell_pos)
		walls.append(cell_pos)
	build_layer.set_cells_terrain_connect(walls,1,0)
		
