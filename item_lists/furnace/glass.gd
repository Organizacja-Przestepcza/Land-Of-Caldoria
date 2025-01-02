extends FurnaceRecipe

func _init() -> void:
	id = "glass"
	result = ItemLoader.name("glass")
	amount = 1
	items = {
		ItemLoader.name("sand"): 2
	}
