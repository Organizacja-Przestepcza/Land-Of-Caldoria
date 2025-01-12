extends BuildRecipe

func _init() -> void:
	name = "Anvil"
	layer = Layer.Object
	is_terrain = false
	source = 2
	result = 7
	items = {
		ItemLoader.name("iron_ingot"): 10
	}
