extends Mob
class_name Enemy
var speed: int
var strength: int
var bounce_force: int = 100

func move_towards_player(target, delta):
	var direction: Vector2 = (target.global_position - self.global_position).normalized()
	var desired_velocity = direction * speed
	var steering = (desired_velocity - velocity) * delta * 2.5
	velocity+=steering
	var collision: KinematicCollision2D = move_and_collide(velocity*delta)
	if collision != null:
		if collision.get_collider() == player:
			attack()
			bounce_back(collision)
	
func attack():
	player.hit(strength)
	
func bounce_back(collision: KinematicCollision2D):
	var bounce_direction = velocity.bounce(collision.get_normal()).normalized()
	velocity = bounce_direction * bounce_force
