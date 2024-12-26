extends VBoxContainer

@onready var game: Game = %Game
var _qm := QuestHandler.quest_manager
var _q_tile_scene := preload("res://scenes/systems/quests/quest_tile.tscn")

func _ready() -> void:
	QuestHandler.quest_started.connect(append_quest)
	_load_quests()

func append_quest(quest: QuestEntry) -> void:
	var quest_tile: QuestTile = _q_tile_scene.instantiate()
	add_child(quest_tile)
	quest_tile.init(quest)
	quest.quest_completed.connect(quest_tile.update_check)
	quest.quest_updated.connect(quest_tile.update_progress)

func _load_quests() -> void:
	# Clear all children
	for child: Node in get_children():
		child.queue_free()
		
	for i in _qm.size():
		var quest = _qm.get_quest(i)
		var quest_tile: QuestTile = _q_tile_scene.instantiate()
		add_child(quest_tile)
		quest_tile.init(quest)
		quest.quest_completed.connect(quest_tile.update_check)
		quest.quest_updated.connect(quest_tile.update_progress)

func open() -> void:
	game.state = Game.State.INVENTORY
