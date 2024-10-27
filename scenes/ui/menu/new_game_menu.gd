extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

signal backbutton_pressed


func _on_back_button_pressed() -> void:
	emit_signal("backbutton_pressed")


func _on_new_game_button_pressed() -> void:
	pass # Replace with function body.
