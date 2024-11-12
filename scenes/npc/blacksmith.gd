extends NPC

func _ready() -> void: 
	super()
	health = 100
	accepted_items = {
		ItemDB.items["pickaxe"] : 0.5,
		ItemDB.items["stone"] : 1,
		ItemDB.items["coal"] : 0.5,
		ItemDB.items["hammer"] : 0.4
	}
