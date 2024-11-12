extends CharacterBody2D
class_name NPC

var inventory : Dictionary
var health : int
var accepted_items: Dictionary
@onready var detection_area:Area2D = get_node("DetectionArea")
func _ready() -> void:
	print("npc")
	var err = 	detection_area.body_entered.connect(on_body_entered)
	print(err)
func on_body_entered(body) -> void:
	if body is Player:
		body.show_trade(self)
