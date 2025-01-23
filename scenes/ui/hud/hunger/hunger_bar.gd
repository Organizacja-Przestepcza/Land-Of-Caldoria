extends Control
class_name Hunger
@onready var player: Player =  $"../../.."
var hunger_decrease_rate: float # the bigger the value, the slower hunger 
var hunger_timer = 0.0
@onready var hunger_bar: TextureProgressBar = %HungerProgressBar 
signal death(cause: String)

func _ready() -> void:
	player = get_tree().current_scene.get_node("Player")
	player.hunger = player.max_hunger
	hunger_decrease_rate = 10.0 - WorldData.difficulty

func _process(delta):
	hunger_timer += delta
	if hunger_timer >= hunger_decrease_rate:
		modify_hunger(-1)
		hunger_timer = 0.0
	if player.hunger <= 0:
		death.emit("hunger")

func modify_hunger(value: int):
	if player.hunger > 0:
		player.hunger += value
		update_hunger_display()

func update_hunger_display():
	hunger_bar.value = float(player.hunger)/player.max_hunger*100
