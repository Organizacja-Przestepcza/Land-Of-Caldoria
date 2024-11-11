extends Destroyable

func _ready() -> void:
	health = 20
	dropped_item = ItemDB.items["log"]
	required_tool = ItemDB.items["axe"]
