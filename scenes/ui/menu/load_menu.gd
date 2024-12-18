extends Control

func _ready() -> void:
	$VBoxContainer/HBoxContainer/LoadButton.disabled = true
	display_saves()

	
func display_saves() -> void:
	$VBoxContainer/LoadList.clear()
	SaveManager.load_all()
	for save: String in SaveManager.saves:
		$VBoxContainer/LoadList.add_item(save.trim_suffix(".tres"))

func _on_cancel_button_pressed() -> void:
	load_cancel_pressed.emit()
	$VBoxContainer/HBoxContainer/LoadButton.disabled = true
	$VBoxContainer/LoadList.deselect_all()

signal load_cancel_pressed


func _on_load_button_pressed() -> void:
	var selected_item = $VBoxContainer/LoadList.get_selected_items()[0]
	var load_name = $VBoxContainer/LoadList.get_item_text(selected_item)
	var load_data = SaveManager.load_game(load_name)

	WorldData.seed = load_data.seed
	WorldData.size = load_data.size
	WorldData.world_name = load_data.world_name
	WorldData.load = load_data
	
	get_tree().change_scene_to_packed(load("res://scenes/world/proc_world.tscn"))


func _on_load_list_item_selected(_index: int) -> void:
	$VBoxContainer/HBoxContainer/LoadButton.disabled = false
