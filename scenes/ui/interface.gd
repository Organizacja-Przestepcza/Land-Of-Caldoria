extends Control
class_name Interface

func open() -> void:
	%Game.state = Game.State.INVENTORY
	get_tree().paused = true
	self.visible = true
	
func close() -> void:
	%Game.state = Game.State.PLAYING
	get_tree().paused = false
	self.visible = false
