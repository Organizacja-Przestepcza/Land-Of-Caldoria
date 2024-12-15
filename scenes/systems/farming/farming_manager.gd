extends Node2D
class_name FarmingManager

@onready var floor_layer: TileMapLayer = $"../FloorLayer"
@onready var grass_layer: TileMapLayer = $"../GrassLayer"
@onready var object_layer: TileMapLayer = $"../ObjectLayer"

func till_ground():
	var mouse_pos = get_local_mouse_position()
	var cell_pos = floor_layer.local_to_map(mouse_pos)
	if grass_layer.get_cell_source_id(cell_pos): # if there is grass
		return
	if floor_layer.get_cell_source_id(cell_pos) == -1 and object_layer.get_cell_source_id(cell_pos) == -1:
		BetterTerrain.set_cell(floor_layer,cell_pos,3) # set cell to unwatered field
		BetterTerrain.update_terrain_cell(floor_layer,cell_pos)

func plant_seed(item: Item):
	pass
