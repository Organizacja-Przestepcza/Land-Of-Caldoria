extends Destroyable

func _ready() -> void:
	health = 30
	dropped_item = ItemDB.items["stone"]
	required_tool = ItemDB.items["pickaxe"]
