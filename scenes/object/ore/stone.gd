extends Destroyable

func _init() -> void:
	health = 30
	dropped_item = ItemLoader.name("stone")
	required_tool = ItemLoader.name("pickaxe")
