extends BuildRecipe

func _init() -> void:
	name = "Table"
	layer = Layer.Object
	is_terrain = false
	source = 2
	result = 3
	items = {
		ItemLoader.name("plank"): 6,
	}
