extends Control

signal backbutton_pressed

func _on_name_field_text_changed(_new_text: String) -> void:
	WorldData.world_name = %NameField.text

func _on_back_button_pressed() -> void:
	backbutton_pressed.emit()

func _on_new_game_button_pressed() -> void:
	var user_seed: int
	var seed_string: String = %SeedField.text
	var size_option = %SizeOption
	if not seed_string.is_empty():
		user_seed = seed_string.hash()
		WorldData.seed = user_seed
	
	if size_option.selected == 3:
		WorldData.size = -1
	else:
		WorldData.size = size_option.selected * 32 + 32
	
	#small 32
	#medium 64
	#large 256
	get_tree().change_scene_to_packed(load("res://scenes/world/proc_world.tscn"))
