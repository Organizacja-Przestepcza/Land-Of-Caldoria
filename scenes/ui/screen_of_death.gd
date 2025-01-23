extends Control

var start_scene = preload("res://scenes/start.tscn")
func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/start.tscn")


func _on_load_button_pressed() -> void:
	SaveManager.load_last_save()

func _ready() -> void:
	$VBoxContainer/MenuButton.grab_focus()
	if WorldData.difficulty == WorldData.Difficulty.NIGHTMARE:
		$VBoxContainer/LoadButton.disabled = true
		SaveManager.remove_world()
