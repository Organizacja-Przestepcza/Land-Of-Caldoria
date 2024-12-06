extends CharacterBody2D
class_name NPC

var inventory : Dictionary
var health : int
var accepted_items: Dictionary
@onready var detection_area:Area2D = get_node("DetectionArea")
func _ready() -> void:
	add_child(load("res://scenes/interactable_area.tscn").instantiate())
