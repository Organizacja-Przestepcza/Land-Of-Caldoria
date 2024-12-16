extends Node2D
class_name FarmingManager

@onready var floor_layer: TileMapLayer = $"../FloorLayer"
@onready var grass_layer: TileMapLayer = $"../GrassLayer"
@onready var object_layer: TileMapLayer = $"../ObjectLayer"
@onready var inventory: Inventory = %Inventory

var crops: Dictionary

func till_ground() -> bool: # if the ground was tilled
	var mouse_pos = get_local_mouse_position()
	var cell_pos = floor_layer.local_to_map(mouse_pos)
	if grass_layer.get_cell_source_id(cell_pos) == -1: # if there is no grass
		return false
	if floor_layer.get_cell_source_id(cell_pos) == -1 and object_layer.get_cell_source_id(cell_pos) == -1:
		BetterTerrain.set_cell(floor_layer,cell_pos,3) # set cell to unwatered field
		BetterTerrain.update_terrain_cell(floor_layer,cell_pos)
		return true
	return false

func plant_seed(item: Item, pos: Vector2):
	print("planting")
	var cell_pos = object_layer.local_to_map(pos)
	if not can_plant(item):
		return false
	if $Timer.is_stopped():
		$Timer.start()
	if item is Consumable:
		if object_layer.get_cell_source_id(cell_pos) != -1:
			return false
		object_layer.set_cell(cell_pos,item.atlas_id,Vector2i.ZERO)
		inventory.remove_item(item, 1)
		var crop_metadata = {
			"type": item,
			"stage": 0,
			"time_to_next_stage": item.hunger_value * 1.0 # in seconds
		}
		crops[cell_pos] = crop_metadata

func is_on_field(pos: Vector2) -> bool:
	var cell_pos = floor_layer.local_to_map(pos)
	return floor_layer.get_cell_source_id(cell_pos) in range(4,6) # is 4 or 5

func can_plant(item: Item) -> bool:
	if item is Consumable:
		return item.is_plantable
	return false

func can_harvest(cell_pos: Vector2i) -> bool:
	var crop_data = crops.get(cell_pos)
	if crop_data is Dictionary:
		if crop_data["stage"] == 1:
			return true
	return false

func _on_timer_timeout() -> void:
	if crops.is_empty():
		$Timer.stop()
	for tile_pos: Vector2i in crops.keys():
		var crop_data = crops.get(tile_pos)
		if crop_data is Dictionary:
			if crop_data["stage"] == 1:
				print("crop grown")
				continue
			var item: Consumable = crop_data.get("type")
			crop_data["time_to_next_stage"] -= 1.0
			if crop_data["time_to_next_stage"] <= 0:
				crop_data["stage"] += 1
				crop_data["time_to_next_stage"] = item.hunger_value * 1.0
				grow_crop(tile_pos)

func grow_crop(tile_pos: Vector2i):
	var atlas_coords = object_layer.get_cell_atlas_coords(tile_pos)
	var source = object_layer.get_cell_source_id(tile_pos)
	atlas_coords.x += 1
	object_layer.set_cell(tile_pos,source,atlas_coords)

func harvest():
	print("harvesting")
	var mouse_pos = get_local_mouse_position()
	if not is_on_field(mouse_pos):
		return
	var cell_pos = floor_layer.local_to_map(mouse_pos)
	if can_harvest(cell_pos):
		var crop_data: Dictionary = crops.get(cell_pos)
		object_layer.erase_cell(cell_pos)
		crops.erase(cell_pos)
		inventory.add_item(crop_data.get("type"), 3)
