extends Enemy

var player
var chase_player = false
func _ready() -> void:
	player = get_parent().get_node("%Player")

func _process(delta: float) -> void:
	if chase_player:
		move_towards_player(player, delta)

func _on_detection_area_body_entered(body: Node2D) -> void:
	print(body)
	chase_player = true


func _on_detection_area_body_exited(body: Node2D) -> void:
	print(body)
	chase_player = false
