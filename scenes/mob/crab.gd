extends Enemy

var chase_player = false
func _ready() -> void:
	health = 20
	speed = 30
	strength = 5
	player = get_parent().get_node("%Player")

func _physics_process(delta: float) -> void:
	if chase_player:
		move_towards_player(player, delta)
		print("Crab: moving")

func _on_detection_area_body_entered(body: Node2D) -> void:
	chase_player = true
	$AnimatedSprite2D.play("moving_top")

func _on_detection_area_body_exited(body: Node2D) -> void:
	chase_player = false
	$AnimatedSprite2D.stop()
	
func attack() -> void:
	$AnimatedSprite2D.play("attack")
