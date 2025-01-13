extends BuildRecipe

func _init() -> void:
	name = "Stand"
	layer = Layer.Object
	is_terrain = false
	source = 2
	result = 4
	items = {
		ItemLoader.name("plank"): 3
	}
