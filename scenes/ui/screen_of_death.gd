extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var start_scene = preload("res://scenes/start.tscn")
func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/start.tscn")
