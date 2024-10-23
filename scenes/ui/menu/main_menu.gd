extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$option_menu.visible = false
	var buttonNewGame = $HBoxContainer/VBoxContainer/StartButton
	buttonNewGame.set_button_label("Start Game")
	
	var buttonLoadGame = $HBoxContainer/VBoxContainer/LoadButton
	buttonLoadGame.set_button_label("Load Game")
	
	var buttonOptions = $HBoxContainer/VBoxContainer/OptionsButton
	buttonOptions.set_button_label("Options")
	
	var buttonExit = $HBoxContainer/VBoxContainer/ExitButton
	buttonExit.set_button_label("Exit")
	
func _on_options_button_pressed() -> void:
	$HBoxContainer.visible = !$HBoxContainer.visible
	$option_menu.visible = !$option_menu.visible

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
