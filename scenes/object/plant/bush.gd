extends Destroyable

func _ready() -> void:
	health = 20
	dropped_item = ItemLoader.items["blueberry"]
