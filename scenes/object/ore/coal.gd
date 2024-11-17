extends Destroyable

func _ready() -> void:
	health = 30
	dropped_item = ItemLoader.name("coal")
	required_tool = ItemLoader.name("pickaxe")
