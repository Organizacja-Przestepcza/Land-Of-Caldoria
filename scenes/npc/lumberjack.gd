extends NPC

func _ready() -> void: 
	super()
	health = 100
	accepted_items = {
		ItemLoader.items["log"] : 0.5,
		ItemLoader.items["axe"] : 3,
		ItemLoader.items["bandage"] : 2,
		ItemLoader.items["blueberry"] : 0.5
	}
