extends Control

signal backbutton_pressed


func _on_back_button_pressed() -> void:
	emit_signal("backbutton_pressed")

func _on_new_game_button_pressed() -> void:
	var user_seed: int
	var seed_string: String = %SeedField.text
	var size_option = %SizeOption
	if not seed_string.is_empty():
		user_seed = seed_string.hash()
		WorldData.seed = user_seed

	WorldData.size = size_option.selected * 32 + 32
	
	#small 32
	#medium 64
	#large 256
	get_tree().change_scene_to_packed(load("res://scenes/world/world.tscn"))
