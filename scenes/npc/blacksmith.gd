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
	inventory = {
		ItemLoader.name("machete"): 1,
		ItemLoader.name("hoe"): 1,
		ItemLoader.name("shovel"): 1,
		ItemLoader.name("hammer"): 1,
		ItemLoader.name("iron ingot"): 8
	}
	QuestHandler._setup_blacksmith_quests(self)

func _setup_dialog():
	dialogs[Dialog.GREET] = {
		0:"Beautiful weather, isn't it?",
		1:"I love the sound of birds singing in the morning.",
		2:"Hello again."
	}
	dialogs[Dialog.PERSONAL] = {
		Dialog.P_SELF: {
			0:"I'm a blacksmith, name's Nathan.",
			1:"I'm an old guy with a hammer."
		},
		Dialog.P_JOB: {
			0:"I make weapons, armor and other stuff. If you want, you can buy some of my equipment. It's top quality.",
			1:"I can repair something that you broke. If I know what it is, of course.",
			2:"Lately, I've been doing mostly nothing, as nobody needs anything."
		},
		Dialog.P_PAST: {
			0:"I once made weapons for the army. During the great war. That was nearly 30 years ago, if I remember correctly.",
			1:"I lost my whole family because of the war. I still see their faces in my dreams."
		}
	}
	dialogs[Dialog.PLACE] = {
		0: "Long ago, there was a road here, popular among merchants. My father used to barter with them. Because of war, nobody comes through here anymore.",
		1: "I've seen some weird ruins lying around, never seen them before the war. I don't know where they came from."
	}
	dialogs[Dialog.QUEST] = {
		0: "You look strong. So tell me strong one, would you go and bring me some iron ore?",
		1: "I have no time for chit chat. I'm busy. I must find something to heat up the furnace. Unless you have something?",
		2: "Do you know how old I am? 72. I love my job but i must drink stamina potions to keep the power I had in my youth. I hope you have some to share?"
	}
