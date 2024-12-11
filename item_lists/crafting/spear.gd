extends CraftingRecipe

func _init() -> void:
	id = "spear"
	result = ItemLoader.name("spear")
	amount = 1
	items = {
	ItemLoader.name("stick"): 2,
	ItemLoader.name("iron_ingot"): 3
	}
