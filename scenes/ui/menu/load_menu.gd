extends Control


func _on_cancel_button_pressed() -> void:
	emit_signal("load_cancel_pressed")

signal load_cancel_pressed
