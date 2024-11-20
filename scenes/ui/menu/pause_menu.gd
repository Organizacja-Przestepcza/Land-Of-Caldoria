extends CanvasLayer
class_name PauseMenu
@onready var game: Node = $"../Game"




func set_initial_menu_state() -> void:
	self.visible = false
	hide_menus()

func hide_menus() -> void:
	$TextureRect.visible = true
	$"%OptionMenu".visible = false
	$"%SaveMenu".visible = false
	$"%LoadMenu".visible = false

func show_menu(menu_node: Node) -> void:
	hide_menus()
	self.visible = true
	menu_node.visible = true
	$TextureRect.visible = false

func _ready() -> void:
	set_initial_menu_state()


func _process(delta: float) -> void:
	if game.state == game.State.PLAYING and Input.is_action_just_pressed("ui_cancel"):
		toggle_menu()


func toggle_menu() -> void:
	pause_toggle()
	self.visible = !self.visible
	hide_menus()


func pause_toggle() -> void:
	get_tree().paused = !get_tree().paused
	#Engine.time_scale = 1 if Engine.time_scale == 0 else 0

signal quit_pressed
func _on_quit_button_pressed() -> void:
	pause_toggle()
	get_tree().change_scene_to_file("res://scenes/start.tscn")

func _on_options_button_pressed() -> void:
	show_menu($"%OptionMenu")

func _on_save_button_pressed() -> void:
	show_menu($"%SaveMenu")

func _on_load_button_pressed() -> void:
	show_menu($"%LoadMenu")
