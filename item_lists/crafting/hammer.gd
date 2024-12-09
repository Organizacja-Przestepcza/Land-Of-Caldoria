extends CraftingRecipe

func _init() -> void:
	id = "hammer"
	result = ItemLoader.name("hammer")
	amount = 1
	items = {
	ItemLoader.name("stick"): 1,
	ItemLoader.name("iron_ingot"): 3
	}
