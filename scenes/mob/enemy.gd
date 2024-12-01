extends Mob
class_name Enemy
var speed: int
var strength: int
var bounce_force: int = 300
@onready var notifications: Notifications = %Notifications

func move_towards_player(target, delta) -> void:
	if target == null:
		return
	var direction: Vector2 = (target.global_position - self.global_position).normalized()
	var desired_velocity = direction * speed
	
	var steering = (desired_velocity - velocity) * delta * 2.5
	velocity+=steering
	
	var collision: KinematicCollision2D = move_and_collide(velocity*delta)
	if collision != null:
		if collision.get_collider() == player:
			attack()
			bounce_back(collision)
		else:
			handle_obstacle(collision)
	
func attack() -> void:
	player.hit(strength)
	notifications.add_notification(mob_name+" hit player: -"+ str(strength) + "hp")
	
func bounce_back(collision: KinematicCollision2D) -> void:
	var bounce_direction = velocity.bounce(collision.get_normal()).normalized()
	velocity = bounce_direction * bounce_force
	
func handle_obstacle(collision: KinematicCollision2D) -> void:
	var obstacle = collision.get_collider()
	if obstacle:
		move_and_slide()
