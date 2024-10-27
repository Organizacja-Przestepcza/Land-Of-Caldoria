extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MarginContainer/OptionMenu.visible = false
	$MarginContainer/MainMenu.connect("options_button_pressed", _on_options_button_pressed)
	$MarginContainer/OptionMenu.connect("backbutton_pressed", _on_options_button_pressed)
	$MarginContainer/MainMenu.connect("exit_button_pressed", _on_exit_button_pressed)


func _on_options_button_pressed() -> void:
	$MarginContainer/MainMenu.visible = !$MarginContainer/MainMenu.visible
	$MarginContainer/OptionMenu.visible = !$MarginContainer/OptionMenu.visible


func _on_exit_button_pressed() -> void:
	get_tree().quit()
