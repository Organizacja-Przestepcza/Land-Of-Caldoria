extends Destroyable

func _init() -> void:
	health = 30
	dropped_item = ItemLoader.name("coal")
	required_tool = ItemLoader.name("pickaxe")
