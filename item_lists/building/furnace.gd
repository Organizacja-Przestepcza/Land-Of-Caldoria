extends BuildRecipe

func _init() -> void:
	name = "Furnace"
	layer = Layer.Object
	is_terrain = false
	source = 2
	result = 2
	items = {
		ItemLoader.name("stone"): 5,
		ItemLoader.name("coal"): 2
	}
