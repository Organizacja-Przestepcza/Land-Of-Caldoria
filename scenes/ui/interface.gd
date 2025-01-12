extends Control
class_name Interface
@onready var game: Game = %Game


func open() -> void:
	game.state = Game.State.INVENTORY
	visible = true
	
func close() -> void:
	game.state = Game.State.PLAYING
	visible = false
