extends FurnaceRecipe

func _init() -> void:
	id = "steak"
	result = ItemLoader.name("steak")
	amount = 1
	items = {
		ItemLoader.name("raw steak"): 1,
		ItemLoader.name("coal"): 1
	}
