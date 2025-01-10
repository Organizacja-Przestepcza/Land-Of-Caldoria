extends Destroyable

func _init() -> void:
	health = 30
	dropped_item = ItemLoader.name("iron_ore")
	required_tool = ItemLoader.name("pickaxe")
