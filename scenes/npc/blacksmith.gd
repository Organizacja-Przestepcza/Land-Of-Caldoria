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
		1:"I love the sound of birds singing in the morning.",
		2:"Hello again."
	}
	dialogs[Dialog.PERSONAL] = {
		0: {
			0:"I'm a blacksmith, name's Nathan.",
			1:"Already told you, you should have payed attention"
		},
		1: {
			0:"I make weapons, armor and other stuff. If you want, you can buy some of my equipment. It's top quality.",
			1:"I can repair something that you broke. If I know what it is, of course."
		},
		2: {
			0:"I once made weapons for the army. During the great war. That was nearly 30 years ago, if I remember correctly. I lost my whole family because of that war."
		}
	}
	dialogs[Dialog.PLACE] = {
		0: "I built this house by myself. And that one, too.",
		1: "I've seen some weird ruins lying around, never seen them before the war. I don't know where they came from."
	}
