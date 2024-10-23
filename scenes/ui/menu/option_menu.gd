extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var BackButton = $MarginContainer/VBoxContainer/BackButton
	BackButton.set_button_label("Go back")

func _on_back_button_button_pressed() -> void:
		emit_signal("backbutton_pressed")
signal backbutton_pressed
