extends FurnaceRecipe

func _init() -> void:
	id = "iron_ingot"
	result = ItemLoader.name("iron_ingot")
	amount = 1
	items = {
		ItemLoader.name("iron_ore"): 2
	}
