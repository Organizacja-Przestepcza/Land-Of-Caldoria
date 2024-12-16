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


func open() -> void:
	game.state = Game.State.INVENTORY
	update()
