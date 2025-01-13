extends BoxContainer
class_name DialogPanel
@onready var game: Game = %Game
@onready var dialog_text: Label = $DialogText

@onready var initial_options: BoxContainer = $InitialOptions
@onready var special_button: Button = $InitialOptions/SpecialButton
@onready var goodbye_button: Button = $InitialOptions/GoodbyeButton

@onready var dialog_options: BoxContainer = $DialogOptions

@onready var quest_options: BoxContainer = $QuestOptions
@onready var accept_button: Button = $QuestOptions/AcceptButton
@onready var reject_button: Button = $QuestOptions/RejectButton

enum _button {
	NEW_QUEST,
	COMPLETE
}

var p_npc: NPC

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
	p_npc = npc
	_goto_main()

func _on_goodbye_button_pressed() -> void:
	hide()

func _on_quest_button_pressed() -> void:
	if p_npc.has_uncompleted_quest:
		dialog_text.text = "Did you do what I asked?" # change to npc specific dialog
		accept_button.text = "I have completed your task"
		accept_button.set_meta(&"type",_button.COMPLETE)
		reject_button.text = "Sorry, I didn't do it yet"
		reject_button.set_meta(&"type",_button.COMPLETE)
	else:
		var quest_dialog = p_npc.dialogs.get(NPC.Dialog.QUEST, {}).get(p_npc.next_quest_id, -1)
		if quest_dialog is String:
			dialog_text.text = quest_dialog
		else:
			dialog_text.text = "I have a task for you. Wanna take it?"
		accept_button.text = "I'll help you"
		accept_button.set_meta(&"type",_button.NEW_QUEST)
		reject_button.text = "Maybe some other time"
		reject_button.set_meta(&"type",_button.NEW_QUEST)
	
	initial_options.hide()
	quest_options.show()
	
func _on_trade_button_pressed() -> void:
	hide()
	get_tree().paused = true
	var trade = WorldData.player.get_node("Interface/Trading") as Trading
	trade.open()

func _on_personal_question_button_pressed() -> void:
	_goto_personal()

func _on_place_question_button_pressed() -> void:
	dialog_text.text = "I don't know much about this place"
	
	var dialogs = p_npc.dialogs.get(NPC.Dialog.PLACE, {})
	if not dialogs.is_empty():
		dialog_text.text = dialogs.values().pick_random()

func _on_special_button_pressed() -> void:
	pass # Replace with function body.

func _on_accept_button_pressed() -> void:
	if p_npc.has_uncompleted_quest:
		if p_npc.next_quest_id < p_npc.quests.size():
			QuestHandler.check_quest_completion(p_npc.quests[p_npc.next_quest_id])
	else:
		if p_npc.dialogs.get(NPC.Dialog.QUEST, {}).size() <= p_npc.next_quest_id: # if no more quests
			QuestHandler.new_random_quest(randi_range(0,1),p_npc)
		else:
			var q = p_npc.quests[p_npc.next_quest_id]
			q.set_active()
			QuestHandler.quest_started.emit(q)
		p_npc.has_uncompleted_quest = true
		_goto_main()

func _on_reject_button_pressed() -> void:
	_goto_main()

func _goto_main():
	initial_options.show()
	quest_options.hide()
	dialog_options.hide()
	goodbye_button.grab_focus()
	
	dialog_text.text = "Hello"
	var dialogs = p_npc.dialogs.get(NPC.Dialog.GREET, {})
	if  not dialogs.is_empty():
		dialog_text.text = dialogs.values().pick_random()

func _goto_personal():
	initial_options.hide()
	quest_options.hide()
	dialog_options.show()
	dialog_text.text = "What do you want to know?"

func _on_back_button_pressed() -> void:
	_goto_main()

func _on_p_self_button_pressed() -> void:
	dialog_text.text = "There's nothing to talk about"
	var dialogs = p_npc.dialogs.get(NPC.Dialog.PERSONAL, {}).get(NPC.Dialog.P_SELF, {})
	if not dialogs.is_empty():
		dialog_text.text = dialogs.values().pick_random()

func _on_p_job_button_pressed() -> void:
	dialog_text.text = "There's nothing to talk about"
	var dialogs = p_npc.dialogs.get(NPC.Dialog.PERSONAL, {}).get(NPC.Dialog.P_JOB, {})
	if not dialogs.is_empty():
		dialog_text.text = dialogs.values().pick_random()

func _on_p_past_buton_pressed() -> void:
	dialog_text.text = "There's nothing to talk about"
	var dialogs = p_npc.dialogs.get(NPC.Dialog.PERSONAL, {}).get(NPC.Dialog.P_PAST, {})
	if not dialogs.is_empty():
		dialog_text.text = dialogs.values().pick_random()
