extends Enemy

func _ready() -> void:
	super()
	health = 40
	speed = 30
	exp = 20
	strength = 15
	$AnimatedSprite2D.play("idle")
