extends Enemy

func _ready() -> void:
	mob_name = "spider"
	super()
	health = 5
	speed = 80
	exp=5
	strength = 5
	$AnimatedSprite2D.play("idle")
	$ProgressBar.max_value = health
	$ProgressBar.value = health
	add_to_group("enemies")
