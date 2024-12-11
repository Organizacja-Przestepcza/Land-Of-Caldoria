extends CraftingRecipe

func _init() -> void:
	id = "metal_pipe"
	result = ItemLoader.name("metal pipe")
	amount = 1
	items = {
	ItemLoader.name("iron_ingot"): 2
	}
