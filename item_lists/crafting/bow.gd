extends CraftingRecipe

func _init() -> void:
	id = "bow"
	result = ItemLoader.name("bow")
	amount = 1
	items = {
	ItemLoader.name("string"): 3,
	ItemLoader.name("iron_ingot"): 1,
	ItemLoader.name("stick"): 3,
	}
