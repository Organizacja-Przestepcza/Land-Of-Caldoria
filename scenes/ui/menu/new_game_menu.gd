extends Control

signal backbutton_pressed


func _on_back_button_pressed() -> void:
	emit_signal("backbutton_pressed")


func _on_new_game_button_pressed() -> void:
	var user_seed: int
	var seedString: String = %SeedField.text
	if not seedString.is_empty():
		user_seed = seedString.hash()
		WorldData.seed = user_seed
	WorldData.size = 64
	get_tree().change_scene_to_packed(preload("res://scenes/world/world.tscn"))
