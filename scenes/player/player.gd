extends CharacterBody2D

@export var speed = 40

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
	elif velocity.y > 0:
		$AnimatedSprite2D.animation = animations[i+1]
	elif velocity.y < 0:
		$AnimatedSprite2D.animation = animations[i+2]

func _physics_process(delta):
	get_input()
	move_and_slide()
	play_animation()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_text_backspace"):
		print(self.position)
