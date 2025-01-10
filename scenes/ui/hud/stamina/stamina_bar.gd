extends Control
class_name Stamina
@onready var player: Player =  $"../../.."
var stamina_decrease_rate = 0.05
var stamina_timer = 0.0
@onready var stamina_progress_bar: TextureProgressBar = %StaminaProgressBar

func _process(delta: float) -> void:

	match player.state:
		player.State.IDLE: modify_stamina(1)
		player.State.WALK: modify_stamina(0)
		player.State.SPRINT: 
			stamina_timer+=delta
			if stamina_timer >= stamina_decrease_rate:
				modify_stamina(-1)
				stamina_timer = 0.0
		
func _ready() -> void:
	player = get_tree().current_scene.get_node("Player")
	player.stamina = player.max_stamina


func modify_stamina(value: int):
	if player.stamina + value < 0 or player.stamina + value > player.max_stamina:
		return
	player.stamina += value
	update_stamina_bar()

func update_stamina_bar():
	stamina_progress_bar.value = float(player.stamina)/player.max_stamina*100
