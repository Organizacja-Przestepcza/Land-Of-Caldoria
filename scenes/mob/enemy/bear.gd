extends Enemy

func _ready() -> void:
	super()
	mob_name = "bear"
	health = 40
	speed = 30
	exp = 20
	strength = 15
	bounce_force = 100
	$AnimatedSprite2D.play("idle")
	$ProgressBar.max_value = health
	$ProgressBar.value = health
	add_to_group("enemies")

func handle_healthbar():
	$ProgressBar.visible = true
	$ProgressBar.value = health
