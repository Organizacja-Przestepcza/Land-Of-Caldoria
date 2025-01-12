extends BoxContainer
class_name DialogPanel
@onready var game: Game = %Game
@onready var dialog_text: Label = $DialogText
@onready var options: BoxContainer = $Options

var p_dialog: DialogueEngine

func _ready() -> void:
	SignalBus.npc_dialog_opened.connect(start_dialog)
	hidden.connect(func(): 
		game.state = game.State.PLAYING
		get_tree().paused = false
		)

func start_dialog(npc: NPC):
	p_dialog = npc.dialog
	if not p_dialog.dialogue_continued.is_connected(_dialog_continued):
		p_dialog.dialogue_continued.connect(_dialog_continued)
	show()
	game.state = game.State.DIALOG
	get_tree().paused = true
	var first_option = options.get_children().front()
	if first_option is Button:
		first_option.grab_focus()
	dialog_text.text = npc.dialog.get_current_entry().get_text()
	$Options/Option.text = str(npc.dialog.get_current_entry_id())

func _dialog_continued(dialog_entry: DialogueEntry):
	dialog_text.text = dialog_entry.get_text()


func _on_dialog_text_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"ui_accept") and visible:
		p_dialog.advance()
