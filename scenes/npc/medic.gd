extends NPC

func _ready() -> void: 
	super()
	health = 1000
	accepted_items = {
		ItemLoader.items["bandage"] : 0.5,
		ItemLoader.items["blueberry"] : 2,
		ItemLoader.items["knife"] : 3
	}
	inventory = {
		ItemLoader.name("bandage"): 2
	}
	QuestHandler

func _setup_dialog():
	dialogs[Dialog.GREET] = {
		0:"Need something?",
		1:"Have we met before?",
		2:"Hello again... I think",
		3:"I recognize you",
	}
	dialogs[Dialog.PERSONAL] = {
		Dialog.P_SELF: {
			0:"I'm a medic, nothing more.",
			1:"My name's not important.",
			2:"It'd be better for you if you didn't know much about me.",
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
		0:"This is Caldoria. It used to be a prosperous land, full of innovations and magic.",
		1:"Nothing's the same after the war. Once there stood high buildings everywhere. Now there's only trees.",
		2:"I hate what has become of this place. I wish I could go back in time before I... before the war.",
		3:"This place is a wasteland. Compared to what it was before."
	}
	dialogs[Dialog.QUEST] = {
		0: "I bought a couple of bottles for my potions. Unfortunately I have no ingredients to make any of those. Take my list and go fetch me a couple of those.",
		1: "I might have overused some of my equipment and now I need to replace it. I can make it myself, just need some parts. Help me get some of the resources I need and I will reward you.",
		2: "I'm out of bottles and I have no money to buy new ones. Bring me some glass so I can make them myself. I will give you some potions in return.",
		3: "Making a potion isn't simple, you know? You need a lot of heat and be careful not to burn your house. Well, I'm out of fuel and pretty busy myself so find something to light it for me.",
		4: "Knife. WHERE IS MY KNIFE! Oh, It's you. Do you have a knife by any chance?",
		5: "I often go to the woods for fun, and herbs. But did you know that some things you can obtain only at night? If only I could see in the dark. Can you help me?",
		6: "I think you've done enough for me to tell you something important. I know you want out and I know how to leave. But it isn't cheap. Bring me a 1000 coins, and I'll take you where you want to go."
	}
