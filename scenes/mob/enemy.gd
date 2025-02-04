extends Mob
class_name Enemy
var speed: int
var strength: int
var bounce_force: int = 300
var chase_player = false:
	set(state):
		sprite.animation = "walk" if state else "idle"
		chase_player = state
		

func _physics_process(delta: float) -> void:
	if chase_player:
		move_towards_player(player, delta)
		if sprite.animation == "attack":
			sprite.flip_h= velocity.x > 0
		else:
			sprite.flip_h= velocity.x < 0

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
			move_and_slide()
	
func attack() -> void:
	player.hit(strength)
	var damage = strength
	SignalBus.player_attacked.emit(mob_name,damage)
	sprite.play("attack")
	play_attack()
	sprite.animation_looped.connect(func (): sprite.animation = "walk" if chase_player else "idle")
	
func bounce_back(collision: KinematicCollision2D) -> void:
	var bounce_direction = velocity.bounce(collision.get_normal()).normalized()
	velocity = bounce_direction * bounce_force

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body is Player and sprite.animation != "death":
		chase_player = true
		play_chase()
		sprite.play("walk")

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body is Player and sprite.animation != "death":
		chase_player = false
		sprite.play("idle")

func take_damage(damage: int) -> bool: ## returns true if the object was destroyed
	chase_player = true
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
	chase_player = false
	SignalBus.enemy_killed.emit(mob_name)
	sprite.play("death")
	sprite.animation_finished.connect(func (): queue_free())

func play_chase() -> void:
	print(mob_name, " chase sound")

func play_attack() -> void:
	print(mob_name, " attack sound")
