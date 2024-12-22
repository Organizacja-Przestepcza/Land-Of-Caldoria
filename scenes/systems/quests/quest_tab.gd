extends VBoxContainer

@onready var game: Game = %Game
var _qm := QuestHandler.quest_manager

func _ready() -> void:
	pass
	#SignalBus.quest_started.connect(append)

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.physical_keycode == KEY_P:
			_qm.get_quest(0).set_completed()

func append() -> void: ## maybe can be used for optimization
	var quest = _qm.get_quest(_qm.size() - 1)
	var quest_tile = QuestTile.new()
	add_child(quest_tile)

func update() -> void:
	# Clear all children
	for child: Node in get_children():
		child.queue_free()
		
	for i in _qm.size():
		var quest = _qm.get_quest(i)
		var quest_tile = QuestTile.new()
		quest_tile.init(quest)
		add_child(quest_tile)
		quest.quest_completed.connect(quest_tile.set_completed)

func open() -> void:
	game.state = Game.State.INVENTORY
	update()
