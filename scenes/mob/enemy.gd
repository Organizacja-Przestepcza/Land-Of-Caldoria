extends Mob
class_name Enemy
var speed: int
var strength: int
var bounce_force: int = 300
var chase_player = false

func _physics_process(delta: float) -> void:
	if chase_player:
		move_towards_player(player, delta)
		if $AnimatedSprite2D.animation == "attack":
			$AnimatedSprite2D.flip_h= velocity.x > 0
		else:
			$AnimatedSprite2D.flip_h= velocity.x < 0

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
	$AnimatedSprite2D.play("attack")
	$AnimatedSprite2D.animation_looped.connect(func (): $AnimatedSprite2D.play("walk"))
	
func bounce_back(collision: KinematicCollision2D) -> void:
	var bounce_direction = velocity.bounce(collision.get_normal()).normalized()
	velocity = bounce_direction * bounce_force
	
func handle_obstacle(collision: KinematicCollision2D) -> void:
	var obstacle = collision.get_collider()
	if obstacle:
		move_and_slide()

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body is Player:
		chase_player = true
		play_chase()
		$AnimatedSprite2D.play("walk")

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body is Player:
		chase_player = false
		$AnimatedSprite2D.play("idle")

func take_damage(damage: int) -> bool: ## returns true if the object was destroyed
	health = health - damage
	if health <= 0:
		die()
		return true
	return false

func die():
	chase_player = false
	$AnimatedSprite2D.play("death")
	$AnimatedSprite2D.animation_finished.connect(func (): queue_free())
func play_chase() -> void:
	print("not implemented")
