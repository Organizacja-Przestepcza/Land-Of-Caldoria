extends CanvasLayer
class_name Hunger

var hunger: int
var hunger_decrease_rate = 10.0
var hunger_timer = 0.0
@onready var hunger_bar: ProgressBar = %HungerProgressBar 
signal death(cause: String)
var player: Player

func _ready() -> void:
	player = get_parent().get_parent()
	hunger = player.hunger

func _process(delta):
	hunger_timer += delta
	if hunger_timer >= hunger_decrease_rate:
		modify_hunger(-1)
		hunger_timer = 0.0
	if hunger <= 0:
		emit_signal("death", "hunger")

func modify_hunger(value: int):
	if hunger > 0:
		hunger += value
		update_hunger_display()

func update_hunger_display():
	hunger_bar.value = float(hunger)/player.hunger*100
