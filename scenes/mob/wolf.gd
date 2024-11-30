extends Enemy

func _ready() -> void:
	super()
	health = 20
	speed = 30
	exp = 5
	strength = 5
	$AnimatedSprite2D.play("idle")
