extends Node2D
class_name BuildManager

@onready var build_menu: BuildMenu = %Building
@onready var floor_layer: TileMapLayer = $"../FloorLayer"
@onready var object_layer: TileMapLayer = $"../ObjectLayer"
@onready var world: ProcWorld = $".."

@onready var layers: Array = [floor_layer,object_layer]

func build() -> bool:
	var mouse_pos = get_local_mouse_position()
	if mouse_pos.distance_to(WorldData.player.position) > 150:
		return false
	var cell_pos = object_layer.local_to_map(mouse_pos)
	
	var recipe = build_menu.get_current_recipe()
	if not recipe:
		print("no recipe selected")
		return false
	
	var layer = object_layer if recipe.layer == BuildRecipe.Layer.Object else floor_layer
	var tiles = world.object_tiles if recipe.layer == BuildRecipe.Layer.Object else world.floor_tiles
	
	var chunk_d: Dictionary = world.get_chunk_data(cell_pos,recipe.layer)
	
	# aborts if at specified tile there exists an object that is not manmade
	var type = chunk_d.get(cell_pos, {}).get("type")
	if type and not type == ProcWorld.ObjType.MANMADE:
		return false
				

	if not build_menu.has_required_ingredients():
		print("cant build")
		return false
	
	if recipe.result == -1:
		if chunk_d.erase(cell_pos):
			BetterTerrain.set_cell(layer,cell_pos,-1)
			BetterTerrain.update_terrain_cell(layer, cell_pos)
	elif not chunk_d.has(cell_pos):
		if recipe.is_terrain: # build terrain
			BetterTerrain.set_cell(layer,cell_pos,recipe.result)
			BetterTerrain.update_terrain_cell(layer, cell_pos)
		elif recipe.result is int: # build from scene collection
			layer.set_cell(cell_pos,recipe.source,Vector2i.ZERO,recipe.result)
		elif recipe.result is Vector2i:
			layer.set_cell(cell_pos,recipe.source,recipe.result,0)
		# Save the tile
		var source = layer.get_cell_source_id(cell_pos)
		var atlas = layer.get_cell_atlas_coords(cell_pos)
		var alt_tile = layer.get_cell_alternative_tile(cell_pos)
		chunk_d[cell_pos] = {
			"type": ProcWorld.ObjType.MANMADE,
			"source": source,
			"atlas_coords": atlas,
			"alt_tile": alt_tile
			}
		build_menu.use_ingredients()
	return true
