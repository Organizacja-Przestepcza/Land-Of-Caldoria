extends Enemy

var chase_player = false
func _ready() -> void:
	health = 20
	speed = 30
	strength = 5
	player = get_parent().get_node("%Player")  # Upewnij się, że ścieżka do gracza jest poprawna.

func _physics_process(delta: float) -> void:
	if chase_player:
		move_towards_player(player, delta)
		print("Bear: moving")

func _on_detection_area_body_entered(body: Node2D) -> void:
	chase_player = true
	update_animation_direction(player.position)


func _on_detection_area_body_exited(body: Node2D) -> void:
	chase_player = false
	$AnimatedSprite2D.play("rest_left")

func update_animation_direction(player_position: Vector2) -> void:
	if player_position.x < global_position.x:
		$AnimatedSprite2D.play("chasing_left")
	else:
		$AnimatedSprite2D.play("chasing_right")

func attack() -> void:
	if player.position.x < global_position.x:
		$AnimatedSprite2D.play("attack_left")
	else:
		$AnimatedSprite2D.play("attack_right")
