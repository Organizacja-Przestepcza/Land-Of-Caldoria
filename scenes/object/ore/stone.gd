extends Destroyable

func _ready() -> void:
	health = 30
	dropped_item = ItemLoader.items["stone"]
	required_tool = ItemLoader.items["pickaxe"]
