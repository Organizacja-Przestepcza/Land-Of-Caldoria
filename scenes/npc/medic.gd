extends NPC

func _ready() -> void: 
	print("medic")
	super()
	health = 100
	accepted_items = {
		ItemLoader.items["bandage"] : 0.5,
		ItemLoader.items["blueberry"] : 2,
		ItemLoader.items["knife"] : 3
	}
	inventory = {
		ItemLoader.name("bandage"): 2
	}
	
