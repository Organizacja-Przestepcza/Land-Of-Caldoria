extends Control

@onready var load_menu: Control = $"../LoadMenu"
@onready var saves_list: ItemList = $VBoxContainer/SavesList
var save_manager: SaveManager
var save_name:String

func _on_cancel_button_pressed() -> void:
	save_cancel_pressed.emit()
	saves_list.deselect_all()
signal save_cancel_pressed

func _ready() -> void:
	display_saves()

func display_saves() -> void:
	saves_list.clear()
	SaveManager.load_all()
	for save:String in SaveManager.saves:
		saves_list.add_item(save.trim_suffix(".tres"))


func _on_save_button_pressed() -> void:
	WorldData.player = get_parent().get_parent()
	save_manager = SaveManager.new()
	
	if saves_list.is_anything_selected():
		save_name = saves_list.get_item_text(saves_list.get_selected_items()[0])
	
	save_manager.save(save_name)
	display_saves()
	load_menu.display_saves()

func _on_save_name_text_changed(new_text: String) -> void:
	save_name = new_text


func _on_saves_list_empty_clicked(_at_position: Vector2, _mouse_button_index: int) -> void:
	saves_list.deselect_all()


func _on_delete_button_pressed() -> void:
	if saves_list.is_anything_selected():
		var selected_item = saves_list.get_item_text(saves_list.get_selected_items()[0])
		var err = SaveManager.remove_save(selected_item)
		if err:
			printerr(error_string(err))
		display_saves()
		load_menu.display_saves()
	
