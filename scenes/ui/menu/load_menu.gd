extends Control
@onready var load_list: ItemList = $VBoxContainer/LoadList

func _ready() -> void:
	$VBoxContainer/HBoxContainer/LoadButton.disabled = true
	SaveManager.load_all()
	display_saves()

	
func display_saves() -> void:
	$VBoxContainer/LoadList.clear()
	for save in SaveManager.get_save_names():
		if save is String:
			$VBoxContainer/LoadList.add_item(save)

func _on_cancel_button_pressed() -> void:
	load_cancel_pressed.emit()
	$VBoxContainer/HBoxContainer/LoadButton.disabled = true
	$VBoxContainer/LoadList.deselect_all()

signal load_cancel_pressed


func _on_load_button_pressed() -> void:
	var selected_item = $VBoxContainer/LoadList.get_selected_items()[0]
	var load_name = $VBoxContainer/LoadList.get_item_text(selected_item)
	SaveManager.load_game_by_name(load_name)


func _on_load_list_item_selected(_index: int) -> void:
	$VBoxContainer/HBoxContainer/LoadButton.disabled = false


func _on_visibility_changed() -> void:
	if visible == true: $VBoxContainer/HBoxContainer/CancelButton.grab_focus()
