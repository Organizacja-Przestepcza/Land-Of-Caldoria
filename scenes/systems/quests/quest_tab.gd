extends VBoxContainer

@onready var game: Game = %Game
@onready var quests: Quests = %QuestManager
var _qm: QuestManager

func _ready() -> void:
	#SignalBus.quest_started.connect(append)
	_qm = quests.quest_manager

func append() -> void: ## maybe can be used for optimization
	var quest = _qm.get_quest(_qm.size() - 1)
	var quest_tile = QuestTile.new(quest)
	add_child(quest_tile)

func update() -> void:
	# Clear all children
	for child: Node in get_children():
		child.queue_free()
		
	for i in _qm.size():
		var quest = _qm.get_quest(i)
		var quest_tile = QuestTile.new(quest)
		add_child(quest_tile)

func open() -> void:
	game.state = Game.State.INVENTORY
	update()
