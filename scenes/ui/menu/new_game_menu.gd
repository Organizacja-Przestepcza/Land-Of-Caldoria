extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%HeaderLabel

func _on_back_button_button_pressed() -> void:
		emit_signal("backbutton_pressed")
signal backbutton_pressed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
