extends CraftingRecipe

func _init() -> void:
	id = "plank"
	result = ItemLoader.name("stone")
	amount = 2
	items = {
	ItemLoader.name("log"): 1
	}
