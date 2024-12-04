extends BuildRecipe

func _init() -> void:
	id = "wooden_wall"
	layer = Layer.Object
	is_terrain = true
	source = 3
	result = 1
	items = {
		ItemLoader.name("log"): 1,
		ItemLoader.name("plank"): 3
	}
