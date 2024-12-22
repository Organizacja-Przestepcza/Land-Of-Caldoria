extends CharacterBody2D
class_name NPC

var inventory : Dictionary
var health : int
var accepted_items: Dictionary
@onready var detection_area:Area2D = get_node("DetectionArea")
@onready var player: Player = %Player
var interaction_dialog: InteractionDialog
var has_given_quest: bool = false

func _ready() -> void:
	add_child(load("res://scenes/interactable_area.tscn").instantiate())
	interaction_dialog = load("res://scenes/npc/interaction_dialog.tscn").instantiate()
	add_child(interaction_dialog)
	interaction_dialog.npc_quest.connect(_on_quest_started)
	interaction_dialog.npc_trade.connect(_on_trade_started)

func show_interaction():
	if interaction_dialog.visible:
		interaction_dialog.hide()
	else:
		interaction_dialog.show()

func _on_quest_started():
	interaction_dialog.hide()
	if has_given_quest:
		return
	var t: String = QuestHandler.Type.keys().pick_random() # picks random type
	SignalBus.quest_started.emit(QuestHandler.Type.get(t))
	has_given_quest = true

func _on_trade_started():
	var node = player.get_node("Interface/Trading")
	if node is Trading:
		interaction_dialog.hide()
		node.open()
	else:
		print("couldnt open trading")
