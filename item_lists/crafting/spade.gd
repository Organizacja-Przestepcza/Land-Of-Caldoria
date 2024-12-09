extends CraftingRecipe

func _init() -> void:
	id = "pickaxe"
	result = ItemLoader.name("pickaxe")
	amount = 1
	items = {
	ItemLoader.name("stick"): 2,
	ItemLoader.name("iron_ingot"): 1
	}
