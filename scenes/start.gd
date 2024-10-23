extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MarginContainer/OptionMenu .visible = false
	
	
func _on_options_button_pressed() -> void:
	$MarginContainer/MainMenu.visible = !$MarginContainer/MainMenu.visible
	$MarginContainer/OptionMenu.visible = !$MarginContainer/MainMenu.visible

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass