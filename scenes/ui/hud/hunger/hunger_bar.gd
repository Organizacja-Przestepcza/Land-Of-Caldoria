extends CanvasLayer
var hunger: int
var hunger_decrease_rate = 10.0
var hunger_timer = 0.0
@onready var hunger_bar = %HungerProgressBar 
signal death(cause: String)

func _ready() -> void:
	var player: Player = get_parent()
	hunger = player.hunger

func _process(delta):
	hunger_timer += delta
	if hunger_timer >= hunger_decrease_rate:
		decrease_hunger()
		hunger_timer = 0.0
	if hunger == 0:
		emit_signal("death", "hunger")

func decrease_hunger():
	if hunger > 0:
		hunger -= 1
		update_hunger_display()

func update_hunger_display():
	hunger_bar.value = hunger
