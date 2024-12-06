extends Node

var lists_trade : Dictionary = {}
var crafting_recipes : Dictionary = {}
var furnace_recipes : Dictionary = {}
var build_recipes: Dictionary = {}

func _ready() -> void:
	load_lists("res://item_lists/crafting")
	load_lists("res://item_lists/trade")
	load_lists("res://item_lists/building")
	load_lists("res://item_lists/furnace")

func load_lists(path: String):
	var files = DirAccess.get_files_at(path)
	for file in files:
		var script: GDScript = load(path+"/"+file)
		var obj: Resource = script.new()
		if obj is ListTrade:
			lists_trade[obj.id] = obj.items
		elif obj is BuildRecipe:
			build_recipes[obj.name] = obj
		elif obj is CraftingRecipe:
			crafting_recipes[obj.id] = obj
		elif obj is FurnaceRecipe:
			furnace_recipes[obj.id] = obj

func trade_id(id: String) -> Dictionary:
	return lists_trade.get(id, {})

func crafting_id(id: String) -> Dictionary:
	return crafting_recipes.get(id, {})
	
func furnace_id(id: String) -> Dictionary:
	return furnace_recipes.get(id, {})
