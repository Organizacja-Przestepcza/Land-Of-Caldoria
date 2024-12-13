class_name Hud
extends CanvasLayer

func _on_death(_cause: String) -> void:
	get_tree().change_scene_to_packed(load("res://scenes/ui/screen_of_death.tscn"))
