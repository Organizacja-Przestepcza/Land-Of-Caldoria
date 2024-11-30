extends Enemy

func _ready() -> void:
	super()
	health = 30
	speed = 50
	exp = 10
	strength = 10
	player = get_parent().get_node("%Player")
	$AnimatedSprite2D.play("idle")

func _physics_process(delta: float) -> void:
	if chase_player:
		move_towards_player(player, delta)
		if $AnimatedSprite2D.animation == "attack":
			$AnimatedSprite2D.flip_h= velocity.x > 0
		else:
			$AnimatedSprite2D.flip_h= velocity.x < 0
			

func _on_detection_area_body_entered(body: Node2D) -> void:
	chase_player = true
	$AnimatedSprite2D.play("walk")

func _on_detection_area_body_exited(body: Node2D) -> void:
	chase_player = false
	$AnimatedSprite2D.play("idle")
	
func attack() -> void:
	super()
	$AnimatedSprite2D.play("attack")
	$AnimatedSprite2D.flip_h= velocity.x > 0
	$AnimatedSprite2D.animation_looped.connect(func (): $AnimatedSprite2D.play("walk"))
