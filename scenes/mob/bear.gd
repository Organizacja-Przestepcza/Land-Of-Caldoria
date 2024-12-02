extends Enemy

func _ready() -> void:
	super()
	mob_name = "Bear"
	health = 40
	speed = 30
	exp = 20
	strength = 15
	$AnimatedSprite2D.play("idle")
	$ProgressBar.max_value = health
	$ProgressBar.value = health

func handle_healthbar():
	$ProgressBar.visible = true
	$ProgressBar.value = health
