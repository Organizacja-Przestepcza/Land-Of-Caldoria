extends Enemy

func _ready() -> void:
	super()
	mob_name = "Crab"
	health = 10
	speed = 100
	exp = 5
	strength = 5
	$ProgressBar.max_value = health
	$ProgressBar.value = health
	add_to_group("enemies")

func handle_healthbar():
	$ProgressBar.visible = true
	$ProgressBar.value = health

func _physics_process(delta: float) -> void:
	if chase_player:
		move_towards_player(player, delta)

func _on_detection_area_body_exited(body: Node2D) -> void:
	chase_player = false
	$AnimatedSprite2D.stop()
	
func play_attack() -> void:
	$AudioStreamPlayer.play()
