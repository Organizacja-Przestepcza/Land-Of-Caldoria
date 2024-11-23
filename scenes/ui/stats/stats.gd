extends Interface
@onready var player: Player = %Player
@onready var hud: Hud = %Hud
@onready var health_bar: ProgressBar = $MarginContainer/VBoxContainer/HealthContainer/HealthBar
@onready var health_label: Label = $MarginContainer/VBoxContainer/HealthContainer/HealthBar/HealthLabel

@onready var hunger_bar: ProgressBar = $MarginContainer/VBoxContainer/HungerContainer/HungerBar
@onready var hunger_label: Label = $MarginContainer/VBoxContainer/HungerContainer/HungerBar/HungerLabel


var current_health_value = 0
var current_hunger_value = 0
var current_exp_value = 0

func open() -> void:
	super()
	set_stats()

func set_stats() -> void:
	update_health()
	update_hunger()
	
func update_health()	-> void:
	current_health_value  = hud.get_node("VBoxContainer/HealthBar").health
	health_bar.value = current_health_value
	health_label.text = str(current_health_value)+"/"+str(player.health)

func update_hunger() -> void:
	current_hunger_value = hud.get_node("VBoxContainer/HungerBar").hunger
	hunger_bar.value = current_hunger_value
	hunger_label.text = str(current_hunger_value) + "/" + str(player.hunger)
	
