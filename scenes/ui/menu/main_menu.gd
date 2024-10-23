extends Control



func _ready() -> void:
	var StartButton = $HBoxContainer/VBoxContainer/StartButton
	StartButton.set_button_label("Start Game")
	
	var LoadButton = $HBoxContainer/VBoxContainer/LoadButton
	LoadButton.set_button_label("Load Game")
	
	var OptionsButton = $HBoxContainer/VBoxContainer/OptionButton
	OptionsButton.set_button_label("Options")
	
	var ExitButton = $HBoxContainer/VBoxContainer/ExitButton
	ExitButton.set_button_label("Exit")


func _on_option_button_button_pressed() -> void:
	emit_signal("options_button_pressed")

signal options_button_pressed


func _on_exit_button_button_pressed() -> void:
	emit_signal("exit_button_pressed")

signal exit_button_pressed
