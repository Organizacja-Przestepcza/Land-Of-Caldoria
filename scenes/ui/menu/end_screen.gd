extends Control

func _on_button_pressed() -> void:
	get_tree().quit()
	#EventAudio.stop(get_tree().root.get_node("World").music_player)
	#get_tree().paused = false
	#WorldData.seed = -1
	#QuestHandler.reset_manager()
	#get_tree().root.get_node("CaveManager").queue_free()
	#get_tree().change_scene_to_file("res://scenes/start.tscn")
