extends CraftingRecipe

func _init() -> void:
	id = "machete"
	result = ItemLoader.name("machete")
	amount = 1
	items = {
	ItemLoader.name("stick"): 1,
	ItemLoader.name("iron_ingot"): 3
	}
