extends BuildRecipe

func _init() -> void:
	name = "Clock"
	layer = Layer.Object
	is_terrain = false
	source = 2
	result = 5
	items = {
		ItemLoader.name("plank"): 4,
		ItemLoader.name("glass"): 2
	}
