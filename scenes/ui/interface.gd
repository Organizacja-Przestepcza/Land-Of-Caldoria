extends Control
class_name Interface
@onready var game: Game = %Game


func open() -> void:
	game.state = Game.State.INVENTORY
	get_tree().paused = true
	self.visible = true
	
func close() -> void:
	game.state = Game.State.PLAYING
	print("close")
	get_tree().paused = false
	self.visible = false
