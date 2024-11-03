extends CanvasLayer

var health: int
@onready var health_bar = %HealthProgressBar
signal death(cause: String)

func _ready() -> void:
	var player: Player = get_parent()
	health = player.health

func _process(delta: float) -> void:
	if health_bar.value == 0:
		emit_signal("death", "health")
