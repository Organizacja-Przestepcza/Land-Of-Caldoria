extends Node

var quest_manager := QuestManager.new()

enum Type {KILL,COLLECT}
enum _key {TYPE,KILL_COUNT,MOB_NAME,TO_KILL}

func _ready():
	SignalBus.enemy_killed.connect(_on_enemy_killed)
	SignalBus.quest_started.connect(new_quest)

func new_quest(type: Type):
	match type:
		Type.KILL: new_kill_quest()
		Type.COLLECT: print("collect")

func new_kill_quest():
	var to_kill = randi_range(2,4)
	var mob_name = MobLoader.get_random_enemy_name()
	
	var title = "Mob hunt: " + mob_name
	var description = "Kill %d %s" % [to_kill, mob_name]
	var quest: QuestEntry = quest_manager.add_quest(title, description)
	
	quest.quest_updated.connect(is_kill_mob_completed)
	quest.quest_completed.connect(func(q: QuestEntry): print("Kill quest %d completed" % q.get_id()))
	
	quest.set_metadata(_key.TYPE,Type.KILL)
	quest.set_metadata(_key.KILL_COUNT,0)
	quest.set_metadata(_key.MOB_NAME,mob_name)
	quest.set_metadata(_key.TO_KILL,to_kill)
	
	quest.set_active()

func is_kill_mob_completed(quest: QuestEntry):
	var _data = quest.get_metadata_data()
	if not _data.has_all([_key.TO_KILL,_key.KILL_COUNT]):
		push_error("Invalid quest data")
		return
	if _data.get(_key.KILL_COUNT) == _data.get(_key.TO_KILL):
		quest.set_completed()

func _on_enemy_killed(mob_name: String):
	for quest in quest_manager._m_quest_entries:
		if quest.is_active() and quest.get_metadata(_key.TYPE) == Type.KILL:
			var curr_kill_count = quest.get_metadata(_key.KILL_COUNT)
			quest.set_metadata(_key.KILL_COUNT,curr_kill_count+1)
			quest.set_updated()

func get_quests() -> Array[QuestEntry]:
	return quest_manager._m_quest_entries
