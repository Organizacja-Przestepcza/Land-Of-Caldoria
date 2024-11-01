extends CanvasLayer
signal death_hunger
var hunger = 100
var hunger_decrease_rate = 15.0
var hunger_timer = 0.0
@onready var hunger_bar = %HungerProgressBar 

func _process(delta):
	hunger_timer += delta
	if hunger_timer >= hunger_decrease_rate:
		decrease_hunger()
		hunger_timer = 0.0
	if hunger == 0:
		emit_signal("death_hunger")
		print("Hunger emits death")

func decrease_hunger():
	if hunger > 0:
		hunger -= 1
		update_hunger_display()

func update_hunger_display():
	hunger_bar.value = hunger
