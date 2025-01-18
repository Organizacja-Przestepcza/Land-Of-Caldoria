extends Neutral

func _ready() -> void:
	mob_name = "sheep"
	health = 10
	super()
	speed = 80
	exp = 3
	$AnimatedSprite2D.play("idle")
	add_to_group("neutrals")
