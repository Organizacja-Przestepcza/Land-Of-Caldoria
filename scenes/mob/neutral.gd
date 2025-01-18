extends Mob
class_name Neutral

var speed: int
var bounce_force: int = 300

	
func take_damage(damage: int) -> bool: ## returns true if the object was destroyed
	if health <= 0:
		if sprite.animation != "death":
			queue_free()
		return false
	health = health - damage
	handle_healthbar()
	if health <= 0:
		die()
		return true
	return false

func die():
	sprite.play("death")
	sprite.animation_finished.connect(func (): queue_free())
