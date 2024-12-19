extends Control

@onready var game: Game = %Game
@onready var quests: Quests = %QuestManager

func _ready() -> void:
	pass

func update() -> void:
	# Clear all children in VBoxContainer
	for i in range($VBoxContainer.get_child_count()):
		var child = $VBoxContainer.get_child(i)
		if child != null:
			child.queue_free()


func open() -> void:
	game.state = Game.State.INVENTORY
	update()
