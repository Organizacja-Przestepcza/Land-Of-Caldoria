extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		self.visible = !self.visible


func _on_continue_button_pressed() -> void:
	self.visible = !self.visible

signal quit_pressed
func _on_quit_button_pressed() -> void:
	emit_signal("quit_pressed")
