extends CraftingRecipe

func _init() -> void:
	id = "crossbow"
	result = ItemLoader.name("crossbow")
	amount = 1
	items = {
	ItemLoader.name("string"): 1,
	ItemLoader.name("iron_ingot"): 1,
	ItemLoader.name("stick"): 1,
	ItemLoader.name("plank"): 2
	}
