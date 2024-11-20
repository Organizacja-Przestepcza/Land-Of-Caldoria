extends Control
class_name Health

var health: int
@onready var health_bar: ProgressBar = %HealthProgressBar
signal death(cause: String)
var player: Player
func _ready() -> void:
	player = get_tree().current_scene.get_node("Player")
	health = player.health

func _process(delta: float) -> void:
	if health <= 0:
		emit_signal("death", "health")
	
func modify_health(value: int) -> void:
	if health > 0:
		health += value
		update_display()

func update_display() -> void:
	health_bar.value = float(health)/player.health*100
