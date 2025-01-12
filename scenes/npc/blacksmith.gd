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

func _setup_dialog():
	dialogs[Dialog.GREET] = {
		0:"Beautiful weather, isn't it?",
		1:"I love the sound of birds singing in the morning",
		2:"Hello again"
		}
	#dialogs[Dialog.PERSONAL]
