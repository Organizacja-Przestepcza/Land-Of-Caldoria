extends Node2D
class_name BuildManager

@onready var building_menu: BuildMenu = $"../Player/Interface/Building"
@onready var build_layer: TileMapLayer = $"../ObjectLayer"
@onready var world: ProcWorld = $".."

var walls: Array = []

func build():
	var mouse_pos = get_local_mouse_position()
	var cell_pos = build_layer.local_to_map(mouse_pos)
	var chunk = world.noise_generator.map_to_chunk(cell_pos)
	if world.object_tiles.has(chunk):
		if world.object_tiles[chunk]
	if building_menu.selected_item == 0:
		BetterTerrain.set_cell(build_layer,cell_pos,-1)
	elif building_menu.selected_item == 1:
		#if cell_pos in walls:
			#return
		print("Hammer time")
		BetterTerrain.set_cell(build_layer,cell_pos,3)
	BetterTerrain.update_terrain_cell(build_layer, cell_pos)
	#build_layer.set_cells_terrain_connect(walls,1,0)
		
