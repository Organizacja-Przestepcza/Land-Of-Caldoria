extends Control

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
	$VBoxContainer/SavesList.clear()

	for save:String in saves:
		$VBoxContainer/SavesList.add_item(save.trim_suffix(".tres"))


func _on_save_button_pressed() -> void:
	WorldData.player = get_parent().get_parent()
	save_manager = SaveManager.new()
	
	if $VBoxContainer/SavesList.is_anything_selected():
		var selected_item = $VBoxContainer/SavesList.get_selected_items()[0]
		save_name = $VBoxContainer/SavesList.get_item_text(selected_item)
		
	var filename = save_manager.save(save_name)
	if saves.find(filename)==-1:
		saves.append(filename)
		display_saves()

func _on_save_name_text_changed(new_text: String) -> void:
	save_name = new_text


func _on_saves_list_empty_clicked(at_position: Vector2, mouse_button_index: int) -> void:
	$VBoxContainer/SavesList.deselect_all()
