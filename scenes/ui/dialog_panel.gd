extends BoxContainer
class_name DialogPanel
@onready var game: Game = %Game
@onready var dialog_text: Label = $DialogText

@onready var initial_options: BoxContainer = $InitialOptions
@onready var dialog_options: BoxContainer = $DialogOptions

@onready var quest_button: Button = $InitialOptions/QuestButton
@onready var trade_button: Button = $InitialOptions/TradeButton
@onready var personal_question_button: Button = $InitialOptions/PersonalQuestionButton
@onready var place_question_button: Button = $InitialOptions/PlaceQuestionButton
@onready var special_button: Button = $InitialOptions/SpecialButton
@onready var goodbye_button: Button = $InitialOptions/GoodbyeButton


var p_dialog: DialogueEngine

func _ready() -> void:
	SignalBus.npc_dialog_opened.connect(start_dialog)
	hidden.connect(func(): 
		game.state = game.State.PLAYING
		get_tree().paused = false
		)

func start_dialog(npc: NPC):
	show()
	game.state = game.State.DIALOG
	get_tree().paused = true
	goodbye_button.grab_focus()
	dialog_text.text = npc.greet_dialogs.pick_random()

func _on_goodbye_button_pressed() -> void:
	hide()


func _on_dialog_options_visibility_changed() -> void:
	initial_options.visible = not dialog_options.visible
