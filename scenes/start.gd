extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MarginContainer/OptionMenu.visible = false
	$MarginContainer/NewGameMenu.visible = false
	
	# Connect signals
	$MarginContainer/MainMenu.connect("options_button_pressed", _on_options_button_pressed)
	$MarginContainer/OptionMenu.connect("backbutton_pressed", _on_options_button_pressed)
	$MarginContainer/NewGameMenu.connect("backbutton_pressed", _on_start_button_pressed)  
	$MarginContainer/MainMenu.connect("exit_button_pressed", _on_exit_button_pressed)
	$MarginContainer/MainMenu.connect("start_button_pressed", _on_start_button_pressed)

# Toggle visibility for Option Menu and Main Menu
func _on_options_button_pressed() -> void:
	$MarginContainer/MainMenu.visible = !$MarginContainer/MainMenu.visible
	$MarginContainer/OptionMenu.visible = !$MarginContainer/OptionMenu.visible

# Quit the game
func _on_exit_button_pressed() -> void:
	get_tree().quit()

# Toggle visibility for New Game Menu and Main Menu
func _on_start_button_pressed() -> void:
	$MarginContainer/MainMenu.visible = !$MarginContainer/MainMenu.visible
	$MarginContainer/NewGameMenu.visible = !$MarginContainer/NewGameMenu.visible


func _on_new_game_menu_backbutton_pressed() -> void:
	print("back pressed from start")
