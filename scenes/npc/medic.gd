extends NPC

func _ready() -> void: 
	health = 100
	accepted_items = [ItemDB.items["bandage"],ItemDB.items["blueberry"],ItemDB.items["knife"]]
	value_multipliers = [0.5,2,3]
