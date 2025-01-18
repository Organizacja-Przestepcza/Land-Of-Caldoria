extends Enemy

func _init() -> void:
	mob_name = "slime"
	health = 20
	speed = 80
	exp = 3
	strength = 5

func _ready() -> void:
	super()
	$AnimatedSprite2D.play("idle")
	add_to_group("enemies")

	
func play_attack() -> void:
	$AudioStreamPlayer.play()
