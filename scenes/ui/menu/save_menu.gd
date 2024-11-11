extends Control


func _on_cancel_button_pressed() -> void:
	emit_signal("save_cancel_pressed")
signal save_cancel_pressed
