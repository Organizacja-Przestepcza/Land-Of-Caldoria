extends CraftingRecipe

func _init() -> void:
	id = "lamp"
	result = ItemLoader.name("lamp")
	amount = 1
	items = {
	ItemLoader.name("glass"): 1,
	ItemLoader.name("iron_ingot"): 2,
	ItemLoader.name("coal"): 1
	}
