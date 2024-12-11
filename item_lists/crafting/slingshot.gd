extends CraftingRecipe

func _init() -> void:
	id = "slingshot"
	result = ItemLoader.name("slingshot")
	amount = 1
	items = {
	ItemLoader.name("string"): 1,
	ItemLoader.name("stick"): 1,
	}
