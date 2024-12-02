extends Enemy

func _ready() -> void:
	super()
	mob_name = "Slime"
	health = 20
	speed = 80
	exp = 3
	strength = 5
	$AnimatedSprite2D.play("idle")
	
func play_attack() -> void:
	$AudioStreamPlayer.play()
