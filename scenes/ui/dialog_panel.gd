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
	p_dialog = npc.dialog
	p_dialog.reset()
	if not p_dialog.dialogue_continued.is_connected(_dialog_continued):
		p_dialog.dialogue_continued.connect(_dialog_continued)
	show()
	game.state = game.State.DIALOG
	get_tree().paused = true
	goodbye_button.grab_focus()
	p_dialog.advance()
	dialog_text.text = npc.dialog.get_current_entry().get_text()

func _dialog_continued(dialog_entry: DialogueEntry):
	dialog_text.text = dialog_entry.get_text()


func _on_goodbye_button_pressed() -> void:
	hide()


func _on_dialog_options_visibility_changed() -> void:
	initial_options.visible = not dialog_options.visible
