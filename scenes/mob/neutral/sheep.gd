extends Neutral

func _ready() -> void:
	mob_name = "Sheep"
	super()
	health = 10
	speed = 80
	exp = 3
	$AnimatedSprite2D.play("idle")
	$ProgressBar.max_value = health
	$ProgressBar.value = health
	add_to_group("neutrals")

func handle_healthbar():
	$ProgressBar.visible = true
	$ProgressBar.value = health
