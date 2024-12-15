extends Neutral

func _ready() -> void:
	super()
	mob_name = "Sheep"
	health = 10
	speed = 80
	exp = 3
	$AnimatedSprite2D.play("idle")
	$ProgressBar.max_value = health
	$ProgressBar.value = health
	add_to_group("enemies")

func handle_healthbar():
	$ProgressBar.visible = true
	$ProgressBar.value = health
