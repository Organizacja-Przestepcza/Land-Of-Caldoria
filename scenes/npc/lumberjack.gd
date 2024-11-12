extends NPC

func _ready() -> void: 
	super()
	health = 100
	accepted_items = {
		ItemDB.items["log"] : 0.5,
		ItemDB.items["axe"] : 3,
		ItemDB.items["bandage"] : 2,
		ItemDB.items["blueberry"] : 0.5
	}
