extends Control
class_name Stats
@onready var player: Player = %Player
@onready var hud: Hud = %Hud
@onready var health_bar: ProgressBar = $MarginContainer/VBoxContainer/HealthContainer/HealthBar
@onready var health_label: Label = $MarginContainer/VBoxContainer/HealthContainer/HealthBar/HealthLabel
@onready var exp_bar: ProgressBar = $MarginContainer/VBoxContainer/ExpContainer/ExpBar
@onready var exp_label: Label = $MarginContainer/VBoxContainer/ExpContainer/ExpBar/ExpLabel
@onready var level_label: Label = $MarginContainer/VBoxContainer/LevelLabel
@onready var hunger_bar: ProgressBar = $MarginContainer/VBoxContainer/HungerContainer/HungerBar
@onready var hunger_label: Label = $MarginContainer/VBoxContainer/HungerContainer/HungerBar/HungerLabel
@onready var strength_label: Label = $MarginContainer/VBoxContainer/StregnthContainer/StrengthLabel
@onready var endurance_label: Label = $MarginContainer/VBoxContainer/EnduranceContainer/EnduranceLabel
@onready var intelligence_label: Label = $MarginContainer/VBoxContainer/IntelligenceContainer/IntelligenceLabel
@onready var luck_label: Label = $MarginContainer/VBoxContainer/LuckContainer/LuckLabel
@onready var agility_label: Label = $MarginContainer/VBoxContainer/AgilityContainer/AgilityLabel



var last_treshold = 0
var next_treshold = 5

func _ready() -> void:
	level_label.text = "Level: " + str(player.level)

func open() -> void:
	set_stats()

func set_stats() -> void:
	update_health()
	update_hunger()
	update_exp()
	set_attrib()
	
func update_health()	-> void:
	health_bar.value = player.health
	health_label.text = str(player.health)+"/"+str(player.max_health)

func update_hunger() -> void:
	hunger_bar.value = player.hunger
	hunger_label.text = str(player.hunger) + "/" + str(player.max_hunger)
	
func update_exp() -> void:
	exp_bar.value = player.exp
	exp_bar.max_value = next_treshold
	exp_label.text = str(player.exp) + "/" + str(next_treshold)
	
func add_exp(amount) -> void:
	player.exp += amount
	while player.exp >= next_treshold: 
		level_up()
		
func level_up() -> void:
	player.exp -= next_treshold
	player.level += 1 
	level_label.text = "Level: " + str(player.level)
	last_treshold = next_treshold
	next_treshold = roundi(2.336*pow(player.level,1.618)+2.5)
	print("Last treshold: ",last_treshold)
	print("Awans na poziom ", player.level, " (następny próg: ", next_treshold, ")")
	
func set_attrib() -> void:
	strength_label.text = "Strength: " + str(player.strength)
	endurance_label.text = "Endurance: " + str(player.endurance)
	intelligence_label.text = "Intelligence: " + str(player.intelligence)
	luck_label.text = "Strength: " + str(player.luck)
	agility_label.text = "Agility: " + str(player.agility)
	
func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_ENTER and event.is_pressed():
			add_exp(1)
