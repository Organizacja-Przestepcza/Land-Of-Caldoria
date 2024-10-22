extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var buttonNewGame = $HBoxContainer/VBoxContainer/start_button
	buttonNewGame.set_button_label("Strat Game")
	
	var buttonLoadGame = $HBoxContainer/VBoxContainer/load_button
	buttonLoadGame.set_button_label("Load Game")
	
	var buttonOptions = $HBoxContainer/VBoxContainer/options_button
	buttonOptions.set_button_label("Options")
	
	var buttonExit = $HBoxContainer/VBoxContainer/exit_button
	buttonExit.set_button_label("Exit")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
