extends CraftingRecipe

func _init() -> void:
	id = "bucket"
	result = ItemLoader.name("bucket")
	amount = 1
	items = {
	ItemLoader.name("plank"): 8,
	ItemLoader.name("iron_ingot"): 1
	}
