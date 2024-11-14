extends Destroyable

func _ready() -> void:
	health = 20
	dropped_item = ItemLoader.items["log"]
	required_tool = ItemLoader.items["axe"]
