extends Enemy

func _init() -> void:
	mob_name = "crab"
	health = 10
	speed = randi_range(90,105)
	exp = 5
	strength = 5

func _ready() -> void:
	super()
	add_to_group("enemies")

func _physics_process(delta: float) -> void:
	if chase_player:
		move_towards_player(player, delta)

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body is Player:
		chase_player = false
		$AnimatedSprite2D.stop()
	
func play_attack() -> void:
	$AudioStreamPlayer.play()
