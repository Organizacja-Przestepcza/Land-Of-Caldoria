extends Enemy

func _ready() -> void:
	mob_name = "wolf"
	super()
	health = 30
	speed = 90
	exp = 10
	strength = 10
	$AnimatedSprite2D.play("idle")
	$ProgressBar.max_value = health
	$ProgressBar.value = health
	add_to_group("enemies")

func handle_healthbar():
	$ProgressBar.visible = true
	$ProgressBar.value = health
