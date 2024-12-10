extends CraftingRecipe

func _init() -> void:
	id = "axe"
	result = ItemLoader.name("axe")
	amount = 1
	items = {
	ItemLoader.name("stick"): 1,
	ItemLoader.name("iron_ingot"): 2
	}
