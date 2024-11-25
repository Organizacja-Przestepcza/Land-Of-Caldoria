extends Node

var lists_trade : Dictionary = {
	
}
var crafting_recipes : Dictionary = {
	
}
var build_recipes : Dictionary = {
	
}
func _ready() -> void:
	load_lists("res://item_lists/crafting")
	load_lists("res://item_lists/trade")
	load_lists("res://item_lists/building")

func load_lists(path: String):
	var files = DirAccess.get_files_at(path)
	for file in files:
		var script: GDScript = load(path+"/"+file)
		var obj: Resource = script.new()
		if obj is ListTrade:
			lists_trade[obj.id] = obj.items
		elif obj is CraftingRecipe:
			crafting_recipes[obj.id] = obj

func trade_id(id: String) -> Dictionary:
	if id in lists_trade.keys():
		return lists_trade[id]
	return {}

func crafting_id(id: String) -> Dictionary:
	if id in crafting_recipes.keys():
		return crafting_recipes[id]
	return {}
