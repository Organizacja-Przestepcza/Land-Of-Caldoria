extends CraftingRecipe

func _init() -> void:
	id = "string"
	result = ItemLoader.name("string")
	amount = 3
	items = {
	ItemLoader.name("stick"): 1,
	ItemLoader.name("wool"): 2
	}
