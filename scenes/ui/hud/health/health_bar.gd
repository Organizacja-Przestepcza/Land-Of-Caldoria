extends CanvasLayer

@onready var health_bar = %HealthProgressBar
signal death
func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	if health_bar.value == 0:
		emit_signal("death")

