extends Control
class_name Stamina
@onready var player: Player =  $"../../.."
var stamina_decrease_rate = 10.0
var stamina_timer = 0.0
@onready var stamina_progress_bar: ProgressBar = %StaminaProgressBar

func _process(delta: float) -> void:
	match player.state:
		player.State.IDLE: modify_stamina(1)
		player.State.WALK: modify_stamina(0)
		player.State.SPRINT: modify_stamina(-1)

func _ready() -> void:
	player = get_tree().current_scene.get_node("Player")
	player.stamina = player.max_stamina


func modify_stamina(value: int):
		player.stamina += value
		update_stamina_bar()

func update_stamina_bar():
	stamina_progress_bar.value = float(player.stamina)/player.max_stamina*100
