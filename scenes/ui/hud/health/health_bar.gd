extends CanvasLayer

@onready var health_bar = %HealthProgressBar
signal death
func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	pass
	#TODO:if health_bar.value == 0:
	#if Input.is_action_pressed("ui_die"):
		#emit_signal("death")
