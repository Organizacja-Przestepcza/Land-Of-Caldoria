extends CraftingRecipe

func _init() -> void:
	id = "crossbow"
	result = ItemLoader.name("crossbow")
	amount = 1
	items = {
	ItemLoader.name("iron_pipe"): 2,
	ItemLoader.name("coal"): 1,
	ItemLoader.name("stick"): 1,
	ItemLoader.name("plank"): 3
	}
