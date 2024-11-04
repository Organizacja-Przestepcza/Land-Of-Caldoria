extends Control


func _ready() -> void:
	$MarginContainer/OptionMenu.visible = false
	$MarginContainer/NewGameMenu.visible = false
	$MarginContainer/LoadMenu.visible = false
	

	$MarginContainer/MainMenu.connect("options_button_pressed", _on_options_button_pressed)
	$MarginContainer/OptionMenu.connect("backbutton_pressed", _on_options_button_pressed)
	$MarginContainer/NewGameMenu.connect("backbutton_pressed", _on_start_button_pressed)  
	$MarginContainer/MainMenu.connect("exit_button_pressed", _on_exit_button_pressed)
	$MarginContainer/MainMenu.connect("start_button_pressed", _on_start_button_pressed)
	$MarginContainer/MainMenu.connect("load_button_pressed", _on_load_button_pressed)
	$MarginContainer/LoadMenu.connect("load_cancel_pressed", _on_load_button_pressed)

func _on_options_button_pressed() -> void:
	$MarginContainer/MainMenu.visible = !$MarginContainer/MainMenu.visible
	$MarginContainer/OptionMenu.visible = !$MarginContainer/OptionMenu.visible


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_start_button_pressed() -> void:
	$MarginContainer/MainMenu.visible = !$MarginContainer/MainMenu.visible
	$MarginContainer/NewGameMenu.visible = !$MarginContainer/NewGameMenu.visible

func _on_load_button_pressed() -> void:
	$MarginContainer/MainMenu.visible = !$MarginContainer/MainMenu.visible
	$MarginContainer/LoadMenu.visible = !$MarginContainer/LoadMenu.visible
	
