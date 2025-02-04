extends Control

signal backbutton_pressed

func _on_name_field_text_changed(_new_text: String) -> void:
	WorldData.world_name = %NameField.text

func _on_back_button_pressed() -> void:
	backbutton_pressed.emit()

func _on_new_game_button_pressed() -> void:
	var user_seed: int
	var seed_string: String = %SeedField.text
	if not seed_string.is_empty():
		user_seed = seed_string.hash()
		WorldData.seed = user_seed
	
	#small 32
	#medium 64
	#large 256
	WorldData.difficulty = $VBoxContainer/DifficultyOptions.get_selected_id()
	get_tree().change_scene_to_packed(load("res://scenes/world/proc_world.tscn"))


func _on_visibility_changed() -> void:
	if visible: %BackButton.grab_focus()


func _on_check_button_toggled(toggled_on: bool) -> void:
	WorldData.is_black = toggled_on
	$VBoxContainer/CheckButton.text = "Black" if toggled_on else "White"
