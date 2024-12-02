extends Enemy

func _ready() -> void:
	mob_name = "Wolf"
	super()
	health = 20
	speed = 30
	exp = 5
	strength = 5
	$AnimatedSprite2D.play("idle")
