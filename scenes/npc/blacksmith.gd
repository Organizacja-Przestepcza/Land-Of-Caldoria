extends NPC

func _ready() -> void: 
	super()
	health = 100
	accepted_items = {
		ItemLoader.items["pickaxe"] : 0.5,
		ItemLoader.items["stone"] : 1,
		ItemLoader.items["coal"] : 0.5,
		ItemLoader.items["hammer"] : 0.4
	}
