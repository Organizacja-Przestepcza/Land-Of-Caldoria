extends CraftingRecipe

func _init() -> void:
	id = "knife"
	result = ItemLoader.name("knife")
	amount = 1
	items = {
	ItemLoader.name("stick"): 1,
	ItemLoader.name("iron_ingot"): 1
	}
