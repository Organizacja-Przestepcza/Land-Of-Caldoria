extends Control

@export var button_label: String :
	get:
		return button_label
	set(value):
		button_label = value

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("MarginContainer/Label").text = "Custom Button"

func set_button_label(new_label: String) -> void:
	button_label = new_label
	$MarginContainer/Label.text = button_label
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
