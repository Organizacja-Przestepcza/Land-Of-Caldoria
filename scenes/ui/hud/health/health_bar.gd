extends Control
class_name Health
@onready var health_bar: TextureProgressBar = %HealthProgressBar
signal death(cause: String)
@onready var player: Player = $"../../.."

func _ready() -> void:
	player = get_tree().current_scene.get_node("Player")
	player.health = player.max_health

func _process(_delta: float) -> void:
	if player.health <= 0:
		death.emit("health")
	
func modify_health(value: int) -> void:
	if player.health > 0:
		player.health += value
		update_display()

func update_display() -> void:
	health_bar.value = float(player.health)/player.max_health*100
