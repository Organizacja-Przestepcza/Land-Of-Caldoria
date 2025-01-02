extends CraftingRecipe

func _init() -> void:
	id = "stick"
	result = ItemLoader.name("stick")
	amount = 2
	items = {
	ItemLoader.name("plank"): 1
	}
