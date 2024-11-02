extends Mob
class_name Enemy
var speed = 20


func move_towards_player(target, delta):
	var direction: Vector2 = (target.global_position - self.global_position).normalized()
	var desired_velocity = direction * speed
	var steering = (desired_velocity - velocity) * delta * 2.5
	velocity+=steering
	move_and_slide()
	
func attack():
	pass
	
