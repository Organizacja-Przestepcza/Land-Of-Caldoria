extends CraftingRecipe

func _init() -> void:
	id = "pickaxe"
	result = ItemLoader.name("pickaxe")
	amount = 1
	items = {
	ItemLoader.name("stick"): 1,
	ItemLoader.name("iron_ingot"): 1
	}