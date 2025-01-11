extends CharacterBody2D
class_name NPC

var inventory : Dictionary
var health : int
var accepted_items: Dictionary
@onready var player: Player = %Player
var interaction_dialog: InteractionDialog
var has_given_quest: bool = false

var greet_dialogs: Array

enum Branch {
	DEFAULT,
	MEDIC,
	BLACKSMITH,
	LUMBERJACK,
	WITCH
}

func _ready() -> void:
	add_child(load("res://scenes/interactable_area.tscn").instantiate())
	_setup_dialog()
	#interaction_dialog = preload("res://scenes/npc/interaction_dialog.tscn").instantiate()
	#add_child(interaction_dialog)
	#interaction_dialog.npc_quest.connect(_on_quest_started)
	#interaction_dialog.npc_trade.connect(_on_trade_started)

func open_dialog():
	SignalBus.npc_dialogue_opened.emit(self)
	#if interaction_dialog.visible:
		#interaction_dialog.hide()
	#else:
		#interaction_dialog.show()

func _on_quest_started() -> void:
	if has_given_quest:
		return
	var type: int = randi_range(0,QuestHandler.Type.size()-1) # picks random type
	QuestHandler.new_quest(type, self)
	has_given_quest = true

func _on_trade_started():
	var node = player.get_node("Interface/Trading") as Trading
	node.open()

func complete_quest(quest: QuestEntry):
	has_given_quest = false
	var reward = quest.get_metadata(QuestHandler._key.REWARD)

func _setup_dialog():
	print("Dialog for %s not setup"%name)
