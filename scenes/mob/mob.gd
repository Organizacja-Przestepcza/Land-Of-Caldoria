extends CharacterBody2D
class_name Mob

var player: Player
var health: int 
var dropped_item: String

func take_damage(damage: int) -> bool: # returns true if the object was destroyed
	health = health - damage
	if health <= 0:
		self.queue_free()
		return true
	return false