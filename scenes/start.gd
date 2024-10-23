extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MarginContainer/OptionMenu .visible = false
	$MarginContainer/MainMenu.connect("options_button_pressed",_on_options_button_pressed)
	
func _on_options_button_pressed() -> void:
	$MarginContainer/MainMenu.visible = false
	$MarginContainer/OptionMenu.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
