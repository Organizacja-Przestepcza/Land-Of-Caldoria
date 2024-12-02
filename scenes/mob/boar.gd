extends Enemy

func _ready() -> void:
	super()
	mob_name = "Boar"
	health = 30
	speed = 50
	exp = 10
	strength = 10
	$AnimatedSprite2D.play("idle")

func play_chase() -> void:
	$AudioStreamPlayer.play()
