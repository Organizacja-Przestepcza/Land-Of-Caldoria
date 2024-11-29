extends Control

@onready var saves_list: ItemList = $VBoxContainer/SavesList
var save_manager: SaveManager
var saves = []
var save_name:String

func _on_cancel_button_pressed() -> void:
	emit_signal("save_cancel_pressed")
	$VBoxContainer/SavesList.deselect_all()
signal save_cancel_pressed

func _ready() -> void:
	display_saves()

func display_saves() -> void:
	saves = SaveManager.load_all()
	saves_list.clear()
	for save:String in saves:
		saves_list.add_item(save.trim_suffix(".tres"))
	print(saves)


func _on_save_button_pressed() -> void:
	WorldData.player = get_parent().get_parent()
	save_manager = SaveManager.new()
	
	if saves_list.is_anything_selected():
		save_name = saves_list.get_item_text(saves_list.get_selected_items()[0])
	
	var filename = save_manager.save(save_name)
	if saves.find(filename)==-1:
		display_saves()

func _on_save_name_text_changed(new_text: String) -> void:
	save_name = new_text


func _on_saves_list_empty_clicked(at_position: Vector2, mouse_button_index: int) -> void:
	saves_list.deselect_all()


func _on_delete_button_pressed() -> void:
	if saves_list.is_anything_selected():
		var selected_item = saves_list.get_item_text(saves_list.get_selected_items()[0])
		var err = SaveManager.remove_save(selected_item)
		if err:
			print(error_string(err))
		display_saves()
