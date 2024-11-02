extends Control



func _ready() -> void:
	var StartButton = $HBoxContainer/VBoxContainer/StartButton
	StartButton.set_label("Start Game")
	
	var LoadButton = $HBoxContainer/VBoxContainer/LoadButton
	LoadButton.set_label("Load Game")
	
	var OptionsButton = $HBoxContainer/VBoxContainer/OptionButton
	OptionsButton.set_label("Options")
	
	var ExitButton = $HBoxContainer/VBoxContainer/ExitButton
	ExitButton.set_label("Exit")


func _on_option_button_button_pressed() -> void:
	emit_signal("options_button_pressed")

signal options_button_pressed


func _on_exit_button_button_pressed() -> void:
	emit_signal("exit_button_pressed")

signal exit_button_pressed


func _on_start_button_button_pressed() -> void:
	emit_signal("start_button_pressed")
	
signal start_button_pressed


func _on_load_button_button_pressed() -> void:
	emit_signal("load_button_pressed")
	print("Load btn pressed")
signal load_button_pressed
