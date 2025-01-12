extends BuildRecipe

func _init() -> void:
	name = "Bookshelf"
	layer = Layer.Object
	is_terrain = false
	source = 2
	result = 6
	items = {
		ItemLoader.name("plank"): 5
	}
