extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
func set_label(new_label: String) -> void:
	$MarginContainer/Button.text = new_label

func _on_button_pressed() -> void:
	button_pressed.emit()
signal button_pressed
