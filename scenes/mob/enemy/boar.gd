extends Enemy

func _ready() -> void:
	super()
	mob_name = "boar"
	health = 30
	speed = 50
	exp = 10
	strength = 10
	bounce_force = 200
	$AnimatedSprite2D.play("idle")
	$ProgressBar.max_value = health
	$ProgressBar.value = health
	add_to_group("enemies")

func play_chase() -> void:
	$AudioStreamPlayer.play()

func handle_healthbar():
	$ProgressBar.visible = true
	$ProgressBar.value = health
