extends CanvasLayer

var paused = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.visible = false
	%OptionMenu.visible = false
	%SaveMenu.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		pauseGameToggle()
		self.visible = !self.visible
		$TextureRect.visible = true 
		$"%OptionMenu".visible = false
		%SaveMenu.visible = false
		
func pauseGameToggle() -> void:
	Engine.time_scale = Engine.time_scale * (-1) + 1
		

func _on_continue_button_pressed() -> void:
	self.visible = !self.visible
	pauseGameToggle()

signal quit_pressed
func _on_quit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/start.tscn")

func _on_options_button_pressed() -> void:
	$TextureRect.visible = false
	%OptionMenu.visible = true

func _on_option_menu_backbutton_pressed() -> void:
	$TextureRect.visible = true 
	$"%OptionMenu".visible = false


func _on_save_button_pressed() -> void:
	$TextureRect.visible = false
	%SaveMenu.visible = true 


func _on_save_menu_cancel_pressed() -> void:
	$TextureRect.visible = true
	%SaveMenu.visible = false 
