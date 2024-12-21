extends Node
class_name Quests

var quest_manager: QuestManager = QuestManager.new()

var _quests: Array[QuestEntry]

enum _type {KILL,COLLECT}
enum _key {TYPE,KILL_COUNT,MOB_NAME,TO_KILL}

func _ready():
	SignalBus.enemy_killed.connect(_on_enemy_killed)
	SignalBus.start_quest.connect(new_quest)
	#var instance = current_quest.instantiate()
	#Questify.start_quest(instance)
	#Questify.condition_query_requested.connect(_on_condition_query_requested)

func new_quest():
	new_kill_quest()

func new_kill_quest():
	var to_kill = randi_range(2,4)
	var mob_name = MobLoader.get_random_enemy_name()
	var title: String = "Kill " + str(to_kill) + " " + mob_name
	var quest: QuestEntry = quest_manager.add_quest(title)
	quest.quest_updated.connect(is_kill_mob_completed)
	quest.quest_completed.connect(func(q: QuestEntry): print(q.get_id()))
	quest.set_metadata(_key.TYPE,_type.KILL)
	quest.set_metadata(_key.KILL_COUNT,0)
	quest.set_metadata(_key.MOB_NAME,mob_name)
	quest.set_metadata(_key.TO_KILL,to_kill)
	quest.set_active()
	_quests.push_back(quest)
	pass

func is_kill_mob_completed(quest: QuestEntry):
	var _data = quest.get_metadata_data()
	if not _data.has_all([_key.TO_KILL,_key.KILL_COUNT]):
		push_error("Invalid quest data")
		return
	if _data.get(_key.KILL_COUNT) == _data.get(_key.TO_KILL):
		quest.set_completed()

func _on_enemy_killed(mob_name: String):
	for quest in _quests:
		if quest.is_active() and quest.get_metadata(_key.TYPE) == _type.KILL:
			var curr_kill_count = quest.get_metadata(_key.KILL_COUNT)
			quest.set_metadata(_key.KILL_COUNT,curr_kill_count+1)
			quest.set_updated()

func get_quests() -> Array[QuestEntry]:
	return _quests
