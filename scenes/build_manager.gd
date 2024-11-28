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
	# checks if at specified tile there exists an object that is not manmade
	if world.object_tiles.has(chunk):
		var coords: Array = world.object_tiles[chunk].keys()
		if cell_pos in coords:
			var type = world.object_tiles[chunk][cell_pos]["type"]
			if type != ProcWorld.ObjType.MANMADE:
				return
	if building_menu.selected_item == 0:
		var chunk_d: Dictionary = world.object_tiles[chunk]
		if chunk_d.erase(cell_pos):
			BetterTerrain.set_cell(build_layer,cell_pos,-1)
			BetterTerrain.update_terrain_cell(build_layer, cell_pos)
	elif building_menu.selected_item == 1:
		#if cell_pos in walls:
			#return
		print("Hammer time")
		var chunk_d: Dictionary = world.object_tiles[chunk]
		if not chunk_d.has(cell_pos):
			BetterTerrain.set_cell(build_layer,cell_pos,3)
			BetterTerrain.update_terrain_cell(build_layer, cell_pos)
			var atlas = build_layer.get_cell_atlas_coords(cell_pos)
			chunk_d[cell_pos] = {
				"type": ProcWorld.ObjType.MANMADE,
				"source": 3,
				"atlas": atlas
			}
	#build_layer.set_cells_terrain_connect(walls,1,0)
		
