extends NPC

func _ready() -> void: 
	health = 100
	accepted_items = [ItemDB.items["pickaxe"],ItemDB.items["stone"],ItemDB.items["coal"],ItemDB.items["hammer"]]
	value_multipliers = [0.5,1,0.5,4]
