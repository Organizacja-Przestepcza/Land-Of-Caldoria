extends Destroyable

func _ready() -> void:
	health = 20
	dropped_item = ItemLoader.name("log")
	required_tool = ItemLoader.name("axe")
