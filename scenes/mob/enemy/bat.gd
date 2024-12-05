extends Enemy

var chase_player = false
func _ready() -> void:
	mob_name = "Bat"
	health = 10
	speed = 40
	strength = 5
	player = get_parent().get_node("%Player")

func _physics_process(delta: float) -> void:
	if chase_player:
		move_towards_player(player, delta)

func _on_detection_area_body_entered(body: Node2D) -> void:
	chase_player = true
	$AnimatedSprite2D.play("walk")

func _on_detection_area_body_exited(body: Node2D) -> void:
	chase_player = false
	
