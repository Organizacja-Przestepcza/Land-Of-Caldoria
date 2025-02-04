extends Control
class_name Stats
@onready var player: Player = %Player
@onready var hud: Hud = %Hud
@onready var health_bar: ProgressBar = $ScrollContainer/MarginContainer/VBoxContainer/HealthContainer/HealthBar
@onready var health_label: Label = $ScrollContainer/MarginContainer/VBoxContainer/HealthContainer/HealthBar/HealthLabel
@onready var exp_bar: ProgressBar = $ScrollContainer/MarginContainer/VBoxContainer/ExpContainer/ExpBar
@onready var exp_label: Label = $ScrollContainer/MarginContainer/VBoxContainer/ExpContainer/ExpBar/ExpLabel
@onready var level_label: Label = $ScrollContainer/MarginContainer/VBoxContainer/HBoxContainer/LevelLabel
@onready var hunger_bar: ProgressBar = $ScrollContainer/MarginContainer/VBoxContainer/HungerContainer/HungerBar
@onready var hunger_label: Label = $ScrollContainer/MarginContainer/VBoxContainer/HungerContainer/HungerBar/HungerLabel
@onready var strength_label: Label = $ScrollContainer/MarginContainer/VBoxContainer/StregnthContainer/StrengthLabel
@onready var endurance_label: Label = $ScrollContainer/MarginContainer/VBoxContainer/EnduranceContainer/EnduranceLabel
@onready var intelligence_label: Label = $ScrollContainer/MarginContainer/VBoxContainer/IntelligenceContainer/IntelligenceLabel
@onready var luck_label: Label = $ScrollContainer/MarginContainer/VBoxContainer/LuckContainer/LuckLabel
@onready var agility_label: Label = $ScrollContainer/MarginContainer/VBoxContainer/AgilityContainer/AgilityLabel
@onready var points_label: Label = $ScrollContainer/MarginContainer/VBoxContainer/HBoxContainer/PointsLabel

@onready var strength_button: Button = $ScrollContainer/MarginContainer/VBoxContainer/StregnthContainer/StrengthButton
@onready var endurance_button: Button = $ScrollContainer/MarginContainer/VBoxContainer/EnduranceContainer/EnduranceButton
@onready var intelligence_button: Button = $ScrollContainer/MarginContainer/VBoxContainer/IntelligenceContainer/IntelligenceButton
@onready var agility_button: Button = $ScrollContainer/MarginContainer/VBoxContainer/AgilityContainer/AgilityButton
@onready var luck_button: Button = $ScrollContainer/MarginContainer/VBoxContainer/LuckContainer/LuckButton
@onready var notifications: Notifications = %Notifications

@export var strength: int = 1:
	set(value):
		strength = value
		strength_label.text = "Strength: " + str(strength)
	get:
		return strength
@export var endurance: int = 1:
	set(value):
		endurance = value
		endurance_label.text = "Endurance: " + str(endurance)
	get:
		return endurance
@export var intelligence: int = 1:
	set(value):
		intelligence = value
		intelligence_label.text = "Intelligence: " + str(intelligence)
	get:
		return intelligence
@export var agility: int = 1:
	set(value):
		agility = value
		agility_label.text = "Agility: " + str(agility)
	get:
		return agility
@export var luck: int = 1:
	set(value):
		luck = value
		luck_label.text = "Luck: " + str(luck)
	get:
		return luck
@export var skill_points: int = 0:
	set(value):
		skill_points = value
		set_btn_state()
		points_label.text = "Avaliable points: " + str(skill_points)
	get:
		return skill_points


var last_treshold = 0
var next_treshold = 5

func _ready() -> void:
	level_label.text = "Level: " + str(player.level)

func open() -> void:
	set_stats()
	strength_button.grab_focus()

func set_stats() -> void:
	update_health()
	update_hunger()
	update_exp()
	
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
	notifications.add_notification("Level up! Current level: %d"%player.level)
	level_label.text = "Level: " + str(player.level)
	last_treshold = next_treshold
	next_treshold = roundi(2.336*pow(player.level,1.618)+2.5)
	add_points()
	
func add_points() -> void:
	skill_points +=2

func set_btn_state() -> void: 
	strength_button.disabled = skill_points < 1
	endurance_button.disabled = skill_points < 1
	intelligence_button.disabled = skill_points < 1
	agility_button.disabled = skill_points < 1
	luck_button.disabled = skill_points < 1

func _on_button_pressed(btn_value: String) -> void:
	if not skill_points > 0:
		return
	skill_points -= 1
	match btn_value:
		"strength": 
			strength += 1
		"endurance":
			endurance += 1
			player.max_health += 10
			player.health += 10
		"intelligence":
			intelligence += 1
		"agility": 
			agility += 1
			player.speed += 5
		"luck": 
			luck += 1
	set_stats()


func _on_visibility_changed() -> void:
	if visible: strength_button.grab_focus()
