extends Control
class_name Stamina
@onready var player: Player =  $"../../.."
var stamina_decrease_rate = 10.0
var stamina_timer = 0.0
@onready var stamina_bar: ProgressBar = %HungerProgressBar 
signal death(cause: String)

func _ready() -> void:
	player = get_tree().current_scene.get_node("Player")
	player.stamina = player.max_stamina

func _process(delta):
	stamina_timer += delta
	if stamina_timer >= stamina_decrease_rate:
		modify_stamina(0)
		stamina_timer = 0.0
	if player.stamina <= 0:
		emit_signal("death", "hunger")

func modify_stamina(value: int):
	if player.stamina > 0:
		player.stamina += value
		update_stamina_bar()

func update_stamina_bar():
	stamina_bar.value = float(player.stamina)/player.max_stamina*100
