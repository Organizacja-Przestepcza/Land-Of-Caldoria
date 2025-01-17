extends CharacterBody2D
class_name NPC

@onready var player: Player = %Player
var inventory : Dictionary
var base_health: int
var health : int
var accepted_items: Dictionary
var has_uncompleted_quest: bool = false
var next_quest_id: int = 0
var dialogs: Dictionary
var quests: Array[QuestEntry]
var _time_since_last_hit: float

enum Dialog {
	GREET,
	PERSONAL,
	PLACE,
	QUEST,
	SPECIAL,
	P_SELF,
	P_JOB,
	P_PAST
}

func _ready() -> void:
	add_child(load("res://scenes/interactable_area.tscn").instantiate())
	_setup_dialog()
	if has_node("HealthBar"):
		$HealthBar.hide()
		$HealthBar.max_value = base_health
		$HealthBar.value = health

func _physics_process(delta: float) -> void:
	if not health < base_health:
		return
	_time_since_last_hit += delta
	if _time_since_last_hit >= 15.0:
		health = base_health
		if has_node("HealthBar"):
			$HealthBar.hide()

func take_damage(damage: int) -> bool: ## returns true if the npc was killed
	health = health - damage
	_time_since_last_hit = 0.0
	if has_node("HealthBar"):
		$HealthBar.show()
		$HealthBar.value = health
	if health <= 0:
		hide()
		process_mode = PROCESS_MODE_DISABLED
		SignalBus.npc_killed.emit(self)
		return true
	return false

func open_dialog():
	SignalBus.npc_dialog_opened.emit(self)

func _setup_dialog():
	print("Dialog for %s not setup"%name)

func _setup_quests():
	pass
