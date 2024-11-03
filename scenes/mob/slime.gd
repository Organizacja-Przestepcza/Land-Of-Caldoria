extends Enemy

var player
var chase_player = false
func _ready() -> void:
	player = get_parent().get_node("%Player")

func _process(delta: float) -> void:
	if chase_player:
		move_towards_player(player, delta)

func _on_detection_area_body_entered(body: Node2D) -> void:
	chase_player = true
	$AnimatedSprite2D.play("chasing")

func _on_detection_area_body_exited(body: Node2D) -> void:
	chase_player = false
	$AnimatedSprite2D.stop()
