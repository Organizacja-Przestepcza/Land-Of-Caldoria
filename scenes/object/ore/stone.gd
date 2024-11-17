extends Destroyable

func _ready() -> void:
	health = 30
	dropped_item = ItemLoader.name("stone")
	required_tool = ItemLoader.name("pickaxe")
