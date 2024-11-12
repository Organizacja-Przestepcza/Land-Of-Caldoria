extends NPC

func _ready() -> void: 
	print("medic")
	super()
	health = 100
	accepted_items = {
		ItemDB.items["bandage"] : 0.5,
		ItemDB.items["blueberry"] : 2,
		ItemDB.items["knife"] : 3
	}

	
