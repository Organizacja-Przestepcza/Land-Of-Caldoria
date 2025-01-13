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
	
func _setup_dialog():
	dialogs[Dialog.GREET] = {
		0:"What brings you here?",
		1:"My beard is itchy",
		2:"I need more sleep",
		3:"I need to sharpen my axes",
	}
	dialogs[Dialog.PERSONAL] = {
		Dialog.P_SELF: {
			0:"I'm Stanley, a lumberjack and a carpenter.",
		},
		Dialog.P_JOB: {
			0:"If you get hurt, I can patch you up. For a right price, of course.",
			1:"I can take care of some bruises and scratches.",
			2:"I can sell you some medicaments or potions.",
		},
		Dialog.P_PAST: {
			0:"None of your business.",
			1:"I don't wanna talk about it.",
			2:"Don't bother me with such nonsense questions.",
			3:"Past is gone. End of story.",
			4:"I'd rather not.",
		}
	}
	dialogs[Dialog.PLACE] = {
		0:"I built this house by myself. And that one, too.",
		1:"There's a lot of bears in the woods, be careful.",
		2:"My home village used to be here.",
	}
	dialogs[Dialog.QUEST] = {
		0: "I cannot chop woods with hungry bears roaming nearby. My tools aren't intended for combat. Go and do something about it.",
		1: "Im proud of my beard but it started to be little too long. I wish I had something to trim it with a little.",
		2: "I did not have enough time to prepare lunch for myself. Can you bring me something to eat?",
		3: "Those wolfs are getting on my nerves lately. How can I work safely when whole bunch of them are here?",
		4: "Nature is beautiful until branches and leaves are scratching your face. Maybe you have something that I can use to get rid of them?"
	}
