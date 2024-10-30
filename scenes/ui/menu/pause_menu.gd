extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.visible = false
	%OptionMenu.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		self.visible = !self.visible
		$MarginContainer/TextureRect.visible = true 
		$"%OptionMenu".visible = false


func _on_continue_button_pressed() -> void:
	self.visible = !self.visible

signal quit_pressed
func _on_quit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/start.tscn")

func _on_options_button_pressed() -> void:
	$MarginContainer/TextureRect.visible = false
	%OptionMenu.visible = true

func _on_option_menu_backbutton_pressed() -> void:
	$MarginContainer/TextureRect.visible = true 
	$"%OptionMenu".visible = false
