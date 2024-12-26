extends Enemy

func _init() -> void:
	mob_name = "bat"
	health = 10
	speed = 40
	strength = 5
	exp = 5

func _ready() -> void:
	add_to_group("enemies")

func _physics_process(delta: float) -> void:
	if chase_player:
		move_towards_player(player, delta)

func _on_detection_area_body_entered(body: Node2D) -> void:
	chase_player = true
	$AnimatedSprite2D.play("walk")

func _on_detection_area_body_exited(body: Node2D) -> void:
	chase_player = false
	
