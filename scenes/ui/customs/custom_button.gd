extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func set_button_label(new_label: String) -> void:
	$MarginContainer/Button.text = new_label
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
