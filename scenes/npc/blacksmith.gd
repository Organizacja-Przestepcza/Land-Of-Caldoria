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
	dialog.set_name("Blacksmith")

func _setup_dialog():
	dialog.add_text_entry("Beautiful weather, isn't it?")
	dialog.add_text_entry("Hello again")
