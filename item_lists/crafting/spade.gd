extends CraftingRecipe

func _init() -> void:
	id = "shovel"
	result = ItemLoader.name("shovel")
	amount = 1
	items = {
	ItemLoader.name("stick"): 2,
	ItemLoader.name("iron_ingot"): 1
	}
