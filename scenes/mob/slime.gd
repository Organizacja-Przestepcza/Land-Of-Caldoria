extends Enemy

func _ready() -> void:
	super()
	health = 20
	speed = 80
	exp = 3
	strength = 5
	$AnimatedSprite2D.play("idle")
