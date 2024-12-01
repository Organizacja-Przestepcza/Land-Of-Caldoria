extends Node2D
class_name BuildManager

@onready var build_menu: BuildMenu = %Building
@onready var ground_layer: TileMapLayer = $"../GroundLayer"
@onready var grass_layer: TileMapLayer = $"../GrassLayer"
@onready var floor_layer: TileMapLayer = $"../FloorLayer"
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
			if not type == ProcWorld.ObjType.MANMADE:
				return
	if build_menu.selected_item == 0:
		var chunk_d = world.object_tiles.get(chunk)
		if not chunk_d is Dictionary:
			world.object_tiles[chunk] = {}
			chunk_d = world.object_tiles.get(chunk)
		if chunk_d.erase(cell_pos):
			BetterTerrain.set_cell(build_layer,cell_pos,-1)
			BetterTerrain.update_terrain_cell(build_layer, cell_pos)
	elif build_menu.selected_item == 1:
		#if cell_pos in walls:
			#return
		var chunk_d = world.object_tiles.get(chunk)
		if not chunk_d is Dictionary:
			world.object_tiles[chunk] = {}
			chunk_d = world.object_tiles.get(chunk)
		if not chunk_d.has(cell_pos):
			BetterTerrain.set_cell(build_layer,cell_pos,0)
			BetterTerrain.update_terrain_cell(build_layer, cell_pos)
			var atlas = build_layer.get_cell_atlas_coords(cell_pos)
			chunk_d[cell_pos] = {
				"type": ProcWorld.ObjType.MANMADE,
				"source": 3,
				"atlas_coords": atlas,
				"alt_tile": 0
			}

func dig():
	var mouse_pos = get_local_mouse_position()
	var cell_pos = build_layer.local_to_map(mouse_pos)
	if not ground_layer.get_cell_source_id(cell_pos) == -1:
		if floor_layer.get_cell_source_id(cell_pos) == -1:
			floor_layer.set_cell(cell_pos,1,Vector2i.ZERO)
		else:
			floor_layer.erase_cell(cell_pos)

func get_floor_at(pos: Vector2i):
	pass
