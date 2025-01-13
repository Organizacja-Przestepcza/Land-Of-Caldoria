extends CharacterBody2D
class_name NPC

var inventory : Dictionary
var health : int
var accepted_items: Dictionary
@onready var player: Player = %Player
var interaction_dialog: InteractionDialog
var has_uncompleted_quest: bool = false
var next_quest_id: int = 0
var dialogs: Dictionary
var quests: Array[QuestEntry]

enum Dialog {
	GREET,
	PERSONAL,
	PLACE,
	QUEST,
	SPECIAL,
	P_SELF,
	P_JOB,
	P_PAST
}

func _ready() -> void:
	add_child(load("res://scenes/interactable_area.tscn").instantiate())
	_setup_dialog()
	QuestHandler.new_random_quest(QuestHandler.Type.COLLECT)

func take_damage(damage: int) -> bool: ## returns true if the npc was killed
	health = health - damage
	if health <= 0:
		hide()
		process_mode = PROCESS_MODE_DISABLED
		SignalBus.npc_killed.emit(self)
		return true
	return false

func open_dialog():
	SignalBus.npc_dialog_opened.emit(self)

func complete_quest(quest: QuestEntry):
	has_uncompleted_quest = false
	next_quest_id += 1
	var reward = quest.get_metadata(QuestHandler._key.REWARD)

func _setup_dialog():
	print("Dialog for %s not setup"%name)

func _setup_quests():
	pass
