extends Control

@onready var game: Game = %Game
@onready var quest_manager = %QuestManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update() -> void:
	# Clear all children in VBoxContainer
	for i in range($VBoxContainer.get_child_count()):
		var child = $VBoxContainer.get_child(i)
		if child != null:
			child.queue_free()

	for quest in Questify.get_quests():
		var label = Label.new()
		if quest.completed:
			var completed = "\u2713" if quest.completed else "\u2717"
			label.text = "Quest: %s\nDescription: %s\nCompleted: %s" % [quest.name, quest.description, completed]
		else:
			var completed = "%s/2" % [quest_manager.current_kills]
			label.text = "Quest: %s\nDescription: %s\nCompleted: %s" % [quest.name, quest.description, completed]
		$VBoxContainer.add_child(label)

func open() -> void:
	game.state = Game.State.INVENTORY
	update()
