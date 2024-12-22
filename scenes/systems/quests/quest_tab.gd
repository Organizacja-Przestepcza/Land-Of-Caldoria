extends VBoxContainer

@onready var game: Game = %Game
var _qm := QuestHandler.quest_manager
var _q_tile_scene := preload("res://scenes/systems/quests/quest_tile.tscn")

func _ready() -> void:
	QuestHandler.quest_started.connect(append)

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.physical_keycode == KEY_P:
			_qm.get_quest(0).set_completed()

func append(quest: QuestEntry) -> void:
	var quest_tile = _q_tile_scene.instantiate()
	add_child(quest_tile)
	quest_tile.init(quest)
	quest.quest_completed.connect(quest_tile.set_completed)

func update() -> void: ## not good to free all children
	# Clear all children
	for child: Node in get_children():
		child.queue_free()
		
	for i in _qm.size():
		var quest = _qm.get_quest(i)
		var quest_tile = _q_tile_scene.instantiate()
		add_child(quest_tile)
		quest_tile.init(quest)
		quest.quest_completed.connect(quest_tile.set_completed)

func open() -> void:
	game.state = Game.State.INVENTORY
