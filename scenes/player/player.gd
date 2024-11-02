extends CharacterBody2D

@export var speed = 40
var facing: Direction = Direction.Down

enum Direction {Down, Up, Right, Left}

func get_input():
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_direction * speed
	if Input.is_action_pressed("sprint"):
		velocity = velocity * 2
		

func play_animation() -> void:
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	# !
	var animations: Array = ["walk_side", "walk_down", "walk_up", "run_side", "run_down", "run_up"]
	var i: int = 0
	if Input.is_action_pressed("sprint"):
		i = 3
	if velocity.x != 0:
		$AnimatedSprite2D.animation = animations[i]
		$AnimatedSprite2D.flip_h = velocity.x < 0
		facing = Direction.Left if velocity.x < 0 else Direction.Right
	elif velocity.y > 0:
		$AnimatedSprite2D.animation = animations[i+1]
		$AnimatedSprite2D.flip_h = 0
		facing = Direction.Down
	elif velocity.y < 0:
		$AnimatedSprite2D.animation = animations[i+2]
		$AnimatedSprite2D.flip_h = 0
		facing = Direction.Up

func _physics_process(delta):
	get_input()
	move_and_slide()
	play_animation()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_text_backspace"):
		print(self.position)
	if Input.is_action_just_pressed("ui_accept"):
		attack()

func attack():
	var hitbox_duration = 0.2
	var length = 30
	var hitbox = ShapeCast2D.new()
	hitbox.shape = RectangleShape2D.new()
	hitbox.position = Vector2i(0,-16)
	hitbox.max_results = 1
	hitbox.collision_mask = 2
	var target: Vector2
	match facing:
		Direction.Down:
			hitbox.shape.size.y = length/2
			hitbox.shape.size.x = length
			target = Vector2i(0,length)
		Direction.Up:
			hitbox.shape.size.y = length/2
			hitbox.shape.size.x = length
			target = Vector2i(0,-length)
		Direction.Right:
			hitbox.shape.size.y = length
			hitbox.shape.size.x = length/2
			target = Vector2i(length,0)
		Direction.Left:
			hitbox.shape.size.y = length
			hitbox.shape.size.x = length/2
			target = Vector2i(-length,0)
	hitbox.target_position = target
	hitbox.enabled = true
	add_child(hitbox)
	await get_tree().create_timer(hitbox_duration).timeout
	hitbox.queue_free()
	if hitbox.is_colliding():
		var victim = hitbox.get_collider(0)
		print("hit on ", victim)
