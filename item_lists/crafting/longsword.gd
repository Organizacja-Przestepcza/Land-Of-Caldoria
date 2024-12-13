extends CraftingRecipe

func _init() -> void:
	id = "longsword"
	result = ItemLoader.name("longsword")
	amount = 1
	items = {
	ItemLoader.name("stick"): 1,
	ItemLoader.name("iron_ingot"): 4
	}
