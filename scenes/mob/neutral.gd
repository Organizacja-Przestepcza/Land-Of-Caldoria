extends Mob
class_name Neutral

var speed: int
var bounce_force: int = 300

	
func take_damage(damage: int) -> bool: ## returns true if the object was destroyed
	if health <= 0:
		if $AnimatedSprite2D.animation != "death":
			queue_free()
		return false
	health = health - damage
	handle_healthbar()
	if health <= 0:
		die()
		return true
	return false

func die():
	$AnimatedSprite2D.play("death")
	$AnimatedSprite2D.animation_finished.connect(func (): queue_free())
