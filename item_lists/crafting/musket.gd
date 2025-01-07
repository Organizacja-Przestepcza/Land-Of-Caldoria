extends CraftingRecipe

func _init() -> void:
	id = "musket"
	result = ItemLoader.name("musket")
	amount = 1
	items = {
	ItemLoader.name("metal_pipe"): 2,
	ItemLoader.name("coal"): 1,
	ItemLoader.name("stick"): 1,
	ItemLoader.name("plank"): 3
	}
