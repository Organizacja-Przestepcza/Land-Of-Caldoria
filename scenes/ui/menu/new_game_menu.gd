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
	get_tree().change_scene_to_packed(load("res://scenes/world/proc_world.tscn"))
