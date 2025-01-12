extends CharacterBody2D
class_name NPC

var inventory : Dictionary
var health : int
var accepted_items: Dictionary
@onready var player: Player = %Player
var interaction_dialog: InteractionDialog
var has_uncompleted_quest: bool = false
var dialogs: Dictionary

enum Dialog {GREET,PERSONAL,PLACE,QUEST}

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

func _on_quest_started() -> void:
	if has_uncompleted_quest:
		return
	var type: int = randi_range(0,QuestHandler.Type.size()-1) # picks random type
	QuestHandler.new_random_quest(type, self)
	has_uncompleted_quest = true

func _on_trade_started():
	var trade = player.get_node("Interface/Trading") as Trading
	trade.open()

func complete_quest(quest: QuestEntry):
	has_uncompleted_quest = false
	var reward = quest.get_metadata(QuestHandler._key.REWARD)

func _setup_dialog():
	print("Dialog for %s not setup"%name)
