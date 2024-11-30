extends Enemy

func _ready() -> void:
	super()
	health = 20
	speed = 80
	exp = 3
	strength = 5
	player = get_parent().get_node("%Player")

func _physics_process(delta: float) -> void:
	if chase_player:
		move_towards_player(player, delta)
		$AnimatedSprite2D.flip_h= velocity.x < 0

func _on_detection_area_body_entered(body: Node2D) -> void:
	chase_player = true
	$AnimatedSprite2D.play("chasing")

func _on_detection_area_body_exited(body: Node2D) -> void:
	chase_player = false
	$AnimatedSprite2D.stop()
