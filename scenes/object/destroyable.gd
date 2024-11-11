class_name Destroyable
extends StaticBody2D

var health: int
var required_tool: Item
var dropped_item: Item

func take_damage(damage: int) -> bool: # returns true if the object was destroyed
	health = health - damage
	if health <= 0:
		self.queue_free()
		return true
	return false
