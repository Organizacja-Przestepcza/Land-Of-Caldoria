extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var StartButton = $HBoxContainer/VBoxContainer/StartButton
	StartButton.set_button_label("Start Game")
	
	var LoadButton = $HBoxContainer/VBoxContainer/LoadButton
	LoadButton.set_button_label("Load Game")
	
	var OptionButton = $HBoxContainer/VBoxContainer/OptionButton
	OptionButton.set_button_label("Options")
	
	var ExitButton = $HBoxContainer/VBoxContainer/ExitButton
	ExitButton.set_button_label("Exit")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_option_button_button_pressed() -> void:
	emit_signal("options_button_pressed")
	
signal options_button_pressed
