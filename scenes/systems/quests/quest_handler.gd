extends Node

var quest_manager := QuestManager.new()

enum Type {KILL,COLLECT,SPECIAL}
enum _key {TYPE,PROGRESS,TARGET,REQUIRED,GIVER,REWARD}

@onready var _possible_items: Array = [
	ItemLoader.name("log"),
	ItemLoader.name("blueberry"),
	ItemLoader.name("stone"),
	ItemLoader.name("iron ore")
]

signal quest_started(quest: QuestEntry)

func _ready():
	quest_manager.set_name("Q Manager")
	SignalBus.enemy_killed.connect(_on_enemy_killed)
	SignalBus.item_added.connect(_on_item_added)

func new_random_quest(type: Type, giver: Variant = null, reward: Variant = null):
	randomize()
	var required: int
	var target # string or Item
	var title: String
	var description: String
	if type == Type.KILL:
		required = randi_range(2,4)
		target = MobLoader.get_random_enemy()
		title = "Mob hunt: " + target.mob_name
		description = "Kill %d %s" % [required, target.mob_name]
		reward = target.health/2
	elif type == Type.COLLECT:
		required = randi_range(4,10)
		target = _possible_items.pick_random()
		title = "Item collector: " + target.name
		description = "Collect %d %s" % [required, target.name]
		reward = target.value * (1 + required)
	var quest: QuestEntry = quest_manager.add_quest(title, description)
	
	quest.quest_updated.connect(check_quest_completion)
	quest.quest_completed.connect(_on_quest_completed)

	quest.set_metadata(_key.TYPE, type)
	quest.set_metadata(_key.PROGRESS, 0)
	quest.set_metadata(_key.TARGET, target)
	quest.set_metadata(_key.REQUIRED, required)
	quest.set_metadata(_key.GIVER, giver)
	quest.set_metadata(_key.REWARD, reward)
	
	quest.set_active()

	quest_started.emit(quest)

func check_quest_completion(quest: QuestEntry) -> void:
	var metadata: Dictionary = quest.get_metadata_data()
	if metadata.get(_key.TYPE) in [Type.KILL, Type.COLLECT]:
		if metadata.get(_key.PROGRESS) >= metadata.get(_key.REQUIRED):
			quest.set_completed()

func _on_enemy_killed(mob_name: String):
	for quest in get_quests():
		if quest.is_active() and not quest.is_completed() and quest.get_metadata(_key.TYPE) == Type.KILL:
			if quest.get_metadata(_key.TARGET).mob_name == mob_name:
				var curr_kill_count = quest.get_metadata(_key.PROGRESS)
				quest.set_metadata(_key.PROGRESS,curr_kill_count+1)
				quest.set_updated()

func _on_item_added(item: Item, amount: int):
	for quest in get_quests():
		if quest.is_active() and not quest.is_completed() and quest.get_metadata(_key.TYPE) == Type.COLLECT:
			if quest.get_metadata(_key.TARGET) == item:
				var progress = quest.get_metadata(_key.PROGRESS)
				if progress+amount >= 0:
					quest.set_metadata(_key.PROGRESS,progress+amount)
					quest.set_updated()

func _on_quest_completed(quest: QuestEntry):
	var giver = quest.get_metadata(_key.GIVER)
	var reward = quest.get_metadata(_key.REWARD)
	if giver is NPC:
		giver.has_given_quest = false
	if reward is int:
		WorldData.player.money.add(reward)
	print("Quest %d completed" % quest.get_id())

func get_quests() -> Array[QuestEntry]:
	return quest_manager._m_quest_entries

func reset_manager() -> void:
	quest_manager.set_data([])
