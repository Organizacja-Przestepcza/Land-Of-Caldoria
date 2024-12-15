extends Mob
class_name Neutral

var speed: int
var bounce_force: int = 300
signal neutral_killed


func handle_healthbar():
	print(mob_name)

func bounce_back(collision: KinematicCollision2D) -> void:
	var bounce_direction = velocity.bounce(collision.get_normal()).normalized()
	velocity = bounce_direction * bounce_force
	
func take_damage(damage: int) -> bool: ## returns true if the object was destroyed
	health = health - damage
	handle_healthbar()
	if health <= 0:
		die()
		return true
	return false

func die():
	neutral_killed.emit(mob_name)
	$AnimatedSprite2D.play("death")
	$AnimatedSprite2D.animation_finished.connect(func (): queue_free())
