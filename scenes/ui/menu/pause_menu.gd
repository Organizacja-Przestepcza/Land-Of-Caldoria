extends CanvasLayer
class_name PauseMenu
@onready var game: Node = $"../Game"

func hide_menus() -> void:
	$TextureRect.visible = true
	$OptionMenu.visible = false
	$SaveMenu.visible = false
	$LoadMenu.visible = false

func show_menu(menu_node: Node) -> void:
	hide_menus()
	menu_node.visible = true
	$TextureRect.visible = false

func _ready() -> void:
	hide_menus()


func _process(_delta: float) -> void:
	if game.state == game.State.PLAYING and Input.is_action_just_pressed("ui_cancel"):
		toggle()


func toggle() -> void:
	get_tree().paused = !get_tree().paused
	self.visible = !self.visible
	hide_menus()


func _on_quit_button_pressed() -> void:
	get_tree().paused = false
	WorldData.seed = -1
	QuestHandler.reset_manager()
	get_tree().change_scene_to_file("res://scenes/start.tscn")

func _on_options_button_pressed() -> void:
	show_menu($OptionMenu)

func _on_save_button_pressed() -> void:
	show_menu($SaveMenu)

func _on_load_button_pressed() -> void:
	show_menu($LoadMenu)
