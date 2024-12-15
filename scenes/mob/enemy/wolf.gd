extends Enemy

func _ready() -> void:
	mob_name = "Wolf"
	super()
	health = 20
	speed = 90
	exp = 5
	strength = 5
	$AnimatedSprite2D.play("idle")
	$ProgressBar.max_value = health
	$ProgressBar.value = health
	add_to_group("enemies")

func handle_healthbar():
	$ProgressBar.visible = true
	$ProgressBar.value = health
