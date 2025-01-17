extends Control
@onready var main_menu: VBoxContainer = $MainMenu
@onready var new_game_menu: Control = $NewGameMenu
@onready var load_menu: Control = $LoadMenu
@onready var option_menu: OptionMenu = $OptionMenu

func _ready() -> void:
	$MainMenu/NewGameButton.grab_focus()
	$EAEventBankMounter.reparent(get_tree().root.get_node("/root/EventAudio"))

func _on_new_game_button_pressed() -> void:
	main_menu.visible = not main_menu.visible
	new_game_menu.visible = not new_game_menu.visible
	
func _on_options_button_pressed() -> void:
	main_menu.visible = not main_menu.visible
	option_menu.visible = not option_menu.visible
	
func _on_load_button_pressed() -> void:
	main_menu.visible = not main_menu.visible
	load_menu.visible = not load_menu.visible
	
func _on_exit_button_pressed() -> void:
	get_tree().quit()
	



func _on_main_menu_visibility_changed() -> void:
	if $MainMenu.visible:
		$MainMenu/NewGameButton.grab_focus()
