extends NPC

func _ready() -> void: 
	health = 100
	accepted_items = [ItemDB.items["log"],ItemDB.items["axe"],ItemDB.items["bandage"],ItemDB.items["blueberry"]]
	value_multipliers = [0.5,3,2,0.5]
