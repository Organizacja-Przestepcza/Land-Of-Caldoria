extends BuildRecipe

func _init() -> void:
	name = "Fence"
	layer = Layer.Object
	is_terrain = true
	source = 7
	result = 1
	items = {
		ItemLoader.name("plank"): 2
	}
