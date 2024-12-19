extends Node
class_name Quests

var quest_manager: QuestManager = QuestManager.new()
var current_quest 
var _mob_kills: Dictionary

var active_quests: Array[QuestEntry]

var current_kills: int = 0

func _ready():
	SignalBus.enemy_killed.connect(_on_enemy_killed)
	new_quest()
	#var instance = current_quest.instantiate()
	#Questify.start_quest(instance)
	#Questify.condition_query_requested.connect(_on_condition_query_requested)

func new_quest():
	var kill_count = randi_range(2,4)
	var mob_name = _mob_kills.keys().pick_random()
	var quest_title: String = "Kill " + str(kill_count) + " " + mob_name
	var quest: QuestEntry = quest_manager.add_quest(quest_title)
	quest.set_metadata("kill_count",kill_count)
	quest.set_metadata("mob_name",mob_name)
	quest.add_completion_condition(is_kill_mob_completed.bind(mob_name,kill_count))
	active_quests.push_back(quest)
	pass

func is_kill_mob_completed(mob_name: String, to_kill: int) -> bool:
	if _mob_kills[mob_name] == to_kill:
		return true
	return false

func _on_enemy_killed(mob_name: String):
	_mob_kills.get_or_add(mob_name, 0)
	_mob_kills[mob_name] += 1
	print("Updated kills for %s: %d"%[mob_name,_mob_kills[mob_name]])
