extends Node

var quest_manager := QuestManager.new()

enum Type {KILL,COLLECT,MONEY,SPECIAL,MULTI}
enum _key {TYPE,PROGRESS,TARGET,REQUIRED,GIVER,REWARD,M_GAIN,M_HAVE}

@onready var _possible_items: Array = [
	ItemLoader.name("log"),
	ItemLoader.name("blueberry"),
	ItemLoader.name("stone"),
	ItemLoader.name("iron ore"),
	ItemLoader.name("coal")
]

signal quest_started(quest: QuestEntry)

func _ready():
	quest_manager.set_name("Q Manager")
	SignalBus.enemy_killed.connect(_on_enemy_killed)
	SignalBus.item_added.connect(_on_item_added)
	SignalBus.coins_changed.connect(_on_coins_changed)

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
	
	quest.quest_completed.connect(_on_quest_completed)
	quest.quest_activated.connect(_on_quest_activated)

	quest.set_metadata(_key.TYPE, type)
	quest.set_metadata(_key.PROGRESS, 0)
	quest.set_metadata(_key.TARGET, target)
	quest.set_metadata(_key.REQUIRED, required)
	quest.set_metadata(_key.GIVER, giver)
	quest.set_metadata(_key.REWARD, reward)
	
	quest.set_active()
	if giver is NPC:
		giver.quests.append(quest)

	quest_started.emit(quest)

func check_quest_completion(quest: QuestEntry) -> bool:
	var metadata: Dictionary = quest.get_metadata_data()
	if quest.has_subquests():
		if quest.are_subquests_completed():
			quest.set_completed()
			return true
	elif metadata.get(_key.TYPE) in [Type.KILL, Type.COLLECT, Type.MONEY]:
		if metadata.get(_key.PROGRESS) >= metadata.get(_key.REQUIRED):
			quest.set_completed()
			return true
	return false

func _on_coins_changed(value: int) -> void:
	for quest in get_quests():
		if quest.is_active() and not quest.is_completed() and quest.get_metadata(_key.TYPE) == Type.MONEY:
			if quest.get_metadata(_key.TARGET) == _key.M_GAIN:
				var curr_money = quest.get_metadata(_key.PROGRESS)
				quest.set_metadata(_key.PROGRESS,curr_money+value)
				quest.set_updated()
			elif quest.get_metadata(_key.TARGET) == _key.M_HAVE:
				var curr_money = WorldData.player.money.get_count()
				quest.set_metadata(_key.PROGRESS,curr_money)
				quest.set_updated()
			
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
			var target = quest.get_metadata(_key.TARGET)
			if target == item:
				var progress = quest.get_metadata(_key.PROGRESS)
				if progress+amount >= 0:
					quest.set_metadata(_key.PROGRESS,progress+amount)
					quest.set_updated()
				
func _on_quest_activated(quest: QuestEntry):
	if quest.get_metadata(_key.TYPE) == Type.COLLECT:
		var required_item = quest.get_metadata(_key.TARGET)
		if not required_item:
			return
		var inventory = WorldData.player.inventory.to_list()
		var amount_in_inventory = inventory.get(required_item, 0)
		quest.set_metadata(_key.PROGRESS, amount_in_inventory)

func _on_quest_completed(quest: QuestEntry):
	var giver = quest.get_metadata(_key.GIVER)
	var reward = quest.get_metadata(_key.REWARD)
	var target = quest.get_metadata(_key.TARGET)
	var required = quest.get_metadata(_key.REQUIRED)
	if giver is NPC:
		giver.has_uncompleted_quest = false
		giver.next_quest_id += 1
	if reward is int:
		WorldData.player.money.add(reward)
		SignalBus.coins_changed.emit(reward)
	elif reward is Item:
		WorldData.player.inventory.add_item(reward, 1)
	if target is Item:
		WorldData.player.inventory.remove_item(target,required)
	print("Quest %d completed" % quest.get_id())

func get_quests() -> Array[QuestEntry]:
	return quest_manager._m_quest_entries

func reset_manager() -> void:
	quest_manager.set_data([])

func _setup_lumberjack_quests(lumberjack: NPC):
	var quest = quest_manager.add_quest("Lumberjack - 1", "Kill 4 bears")
	quest.set_metadata(_key.TYPE, Type.KILL)
	quest.set_metadata(_key.PROGRESS, 0)
	quest.set_metadata(_key.TARGET, "bear")
	quest.set_metadata(_key.REQUIRED, 4)
	quest.set_metadata(_key.GIVER, lumberjack)
	quest.set_metadata(_key.REWARD, ItemLoader.name("iron leggings"))
	quest.quest_completed.connect(_on_quest_completed)
	quest.quest_activated.connect(_on_quest_activated)
	lumberjack.quests.append(quest)
	
	quest = quest_manager.add_quest("Lumberjack - 2", "Bring shears")
	quest.set_metadata(_key.TYPE, Type.COLLECT)
	quest.set_metadata(_key.PROGRESS, 0)
	quest.set_metadata(_key.TARGET, ItemLoader.name("shears"))
	quest.set_metadata(_key.REQUIRED, 1)
	quest.set_metadata(_key.GIVER, lumberjack)
	quest.set_metadata(_key.REWARD, ItemLoader.name("iron leggings"))
	quest.quest_completed.connect(_on_quest_completed)
	quest.quest_activated.connect(_on_quest_activated)
	lumberjack.quests.append(quest)
	
	quest = quest_manager.add_quest("Lumberjack - 3", "Bring 7 carrots")
	quest.set_metadata(_key.TYPE, Type.COLLECT)
	quest.set_metadata(_key.PROGRESS, 0)
	quest.set_metadata(_key.TARGET, ItemLoader.name("carrot"))
	quest.set_metadata(_key.REQUIRED, 7)
	quest.set_metadata(_key.GIVER, lumberjack)
	quest.set_metadata(_key.REWARD, 40)
	quest.quest_completed.connect(_on_quest_completed)
	quest.quest_activated.connect(_on_quest_activated)
	lumberjack.quests.append(quest)
	
	quest = quest_manager.add_quest("Lumberjack - 4", "Kill 5 wolfs")
	quest.set_metadata(_key.TYPE, Type.KILL)
	quest.set_metadata(_key.PROGRESS, 0)
	quest.set_metadata(_key.TARGET, "wolf")
	quest.set_metadata(_key.REQUIRED, 4)
	quest.set_metadata(_key.GIVER, lumberjack)
	quest.set_metadata(_key.REWARD, 70)
	quest.quest_completed.connect(_on_quest_completed)
	quest.quest_activated.connect(_on_quest_activated)
	lumberjack.quests.append(quest)
	
	quest = quest_manager.add_quest("Lumberjack - 5", "Bring machete")
	quest.set_metadata(_key.TYPE, Type.COLLECT)
	quest.set_metadata(_key.PROGRESS, 0)
	quest.set_metadata(_key.TARGET, ItemLoader.name("machete"))
	quest.set_metadata(_key.REQUIRED, 1)
	quest.set_metadata(_key.GIVER, lumberjack)
	quest.set_metadata(_key.REWARD, 100)
	quest.quest_completed.connect(_on_quest_completed)
	quest.quest_activated.connect(_on_quest_activated)
	lumberjack.quests.append(quest)

func _setup_blacksmith_quests(blacksmith: NPC):
	var quest = quest_manager.add_quest("Blacksmith - 1", "Bring 5 iron ore")
	quest.set_metadata(_key.TYPE, Type.COLLECT)
	quest.set_metadata(_key.PROGRESS, 0)
	quest.set_metadata(_key.TARGET, ItemLoader.name("iron ore"))
	quest.set_metadata(_key.REQUIRED, 5)
	quest.set_metadata(_key.GIVER, blacksmith)
	quest.set_metadata(_key.REWARD, ItemLoader.name("iron chestplate"))
	quest.quest_completed.connect(_on_quest_completed)
	quest.quest_activated.connect(_on_quest_activated)
	blacksmith.quests.append(quest)
	
	quest = quest_manager.add_quest("Blacksmith - 2", "Bring 10 coal")
	quest.set_metadata(_key.TYPE, Type.COLLECT)
	quest.set_metadata(_key.PROGRESS, 0)
	quest.set_metadata(_key.TARGET, ItemLoader.name("coal"))
	quest.set_metadata(_key.REQUIRED, 10)
	quest.set_metadata(_key.GIVER, blacksmith)
	quest.set_metadata(_key.REWARD, ItemLoader.name("iron boots"))
	quest.quest_completed.connect(_on_quest_completed)
	quest.quest_activated.connect(_on_quest_activated)
	blacksmith.quests.append(quest)
	
	quest = quest_manager.add_quest("Blacksmith - 3", "Bring 3 stamina potions")
	quest.set_metadata(_key.TYPE, Type.COLLECT)
	quest.set_metadata(_key.PROGRESS, 0)
	quest.set_metadata(_key.TARGET, ItemLoader.name("stamina potion"))
	quest.set_metadata(_key.REQUIRED, 3)
	quest.set_metadata(_key.GIVER, blacksmith)
	quest.set_metadata(_key.REWARD, ItemLoader.name("iron boots"))
	quest.quest_completed.connect(_on_quest_completed)
	quest.quest_activated.connect(_on_quest_activated)
	blacksmith.quests.append(quest)

func _setup_medic_quests(medic: NPC):
	var quest = quest_manager.add_quest("Medic - 1", "Bring 10 berries")
	quest.set_metadata(_key.TYPE, Type.COLLECT)
	quest.set_metadata(_key.PROGRESS, 0)
	quest.set_metadata(_key.TARGET, ItemLoader.name("blueberry"))
	quest.set_metadata(_key.REQUIRED, 10)
	quest.set_metadata(_key.GIVER, medic)
	quest.set_metadata(_key.REWARD, 50)
	quest.quest_completed.connect(_on_quest_completed)
	quest.quest_activated.connect(_on_quest_activated)
	medic.quests.append(quest)

	quest = quest_manager.add_quest("Medic - 2", "Bring 5 metal pipes")
	quest.set_metadata(_key.TYPE, Type.COLLECT)
	quest.set_metadata(_key.PROGRESS, 0)
	quest.set_metadata(_key.TARGET, ItemLoader.name("metal pipe"))
	quest.set_metadata(_key.REQUIRED, 5)
	quest.set_metadata(_key.GIVER, medic)
	quest.set_metadata(_key.REWARD, 80)
	quest.quest_completed.connect(_on_quest_completed)
	quest.quest_activated.connect(_on_quest_activated)
	medic.quests.append(quest)
	
	quest = quest_manager.add_quest("Medic - 3", "Bring 8 glass")
	quest.set_metadata(_key.TYPE, Type.COLLECT)
	quest.set_metadata(_key.PROGRESS, 0)
	quest.set_metadata(_key.TARGET, ItemLoader.name("glass"))
	quest.set_metadata(_key.REQUIRED, 8)
	quest.set_metadata(_key.GIVER, medic)
	quest.set_metadata(_key.REWARD, ItemLoader.name("stamina potion"))
	quest.quest_completed.connect(_on_quest_completed)
	quest.quest_activated.connect(_on_quest_activated)
	medic.quests.append(quest)
	
	quest = quest_manager.add_quest("Medic - 4", "Bring 10 logs")
	quest.set_metadata(_key.TYPE, Type.COLLECT)
	quest.set_metadata(_key.PROGRESS, 0)
	quest.set_metadata(_key.TARGET, ItemLoader.name("log"))
	quest.set_metadata(_key.REQUIRED, 10)
	quest.set_metadata(_key.GIVER, medic)
	quest.set_metadata(_key.REWARD, 30)
	quest.quest_completed.connect(_on_quest_completed)
	quest.quest_activated.connect(_on_quest_activated)
	medic.quests.append(quest)
	
	quest = quest_manager.add_quest("Medic - 5", "Bring 1 knife")
	quest.set_metadata(_key.TYPE, Type.COLLECT)
	quest.set_metadata(_key.PROGRESS, 0)
	quest.set_metadata(_key.TARGET, ItemLoader.name("knife"))
	quest.set_metadata(_key.REQUIRED, 1)
	quest.set_metadata(_key.GIVER, medic)
	quest.set_metadata(_key.REWARD, 50)
	quest.quest_completed.connect(_on_quest_completed)
	quest.quest_activated.connect(_on_quest_activated)
	medic.quests.append(quest)
	
	quest = quest_manager.add_quest("Medic - 6", "Bring 1 lamp")
	quest.set_metadata(_key.TYPE, Type.COLLECT)
	quest.set_metadata(_key.PROGRESS, 0)
	quest.set_metadata(_key.TARGET, ItemLoader.name("lamp"))
	quest.set_metadata(_key.REQUIRED, 1)
	quest.set_metadata(_key.GIVER, medic)
	quest.set_metadata(_key.REWARD, 150)
	quest.quest_completed.connect(_on_quest_completed)
	quest.quest_activated.connect(_on_quest_activated)
	medic.quests.append(quest)
	
	quest = quest_manager.add_quest("We're in the end game now", "Bring 1000 coins to Medic and leave Caldoria")
	quest.set_metadata(_key.TYPE, Type.MONEY)
	quest.set_metadata(_key.PROGRESS, 0)
	quest.set_metadata(_key.TARGET, _key.M_HAVE)
	quest.set_metadata(_key.REQUIRED, 1)
	quest.set_metadata(_key.GIVER, medic)
	quest.quest_completed.connect(_end_quest_completed)
	quest.quest_activated.connect(_on_quest_activated)
	medic.quests.append(quest)

func _end_quest_completed(quest: QuestEntry):
	get_tree().change_scene_to_file("res://scenes/ui/menu/end_screen.tscn")
