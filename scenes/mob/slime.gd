extends Enemy

var player
func _ready() -> void:
	player = get_parent().get_node("%Player")

func _process(delta: float) -> void:
	move_towards_player(player, delta)
