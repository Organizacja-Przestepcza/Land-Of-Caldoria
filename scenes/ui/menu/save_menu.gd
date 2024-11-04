extends Control

var save: SaveGame
var saves_array = []
func _on_cancel_button_pressed() -> void:
	emit_signal("save_cancel_pressed")
signal save_cancel_pressed

func _ready() -> void:
	saves_array = SaveGame.load_saved_games()
	display_saves()

func display_saves() -> void:
	$VBoxContainer/SavesList.clear()

	for save_game in saves_array:
		$VBoxContainer/SavesList.add_item(save_game)
		print(save_game)


func _on_save_button_pressed() -> void:
	save = SaveGame.new()
	var filename = save.write_save_game("")
	if saves_array.find(filename)==-1:
		saves_array.append(filename)
		display_saves()
