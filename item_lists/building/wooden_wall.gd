extends BuildRecipe

func _init() -> void:
	name = "Wooden Wall"
	layer = Layer.Object
	is_terrain = true
	source = 3
	result = 0
	items = {
		ItemLoader.name("log"): 1,
		ItemLoader.name("plank"): 3
	}
