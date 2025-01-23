extends Enemy

func _init() -> void:
	mob_name = "slime"
	health = 20 + WorldData.difficulty * 5
	speed = randi_range(60,90)
	exp = 3 + WorldData.difficulty * 2
	strength = 5 + WorldData.difficulty * 2

func _ready() -> void:
	super()
	$AnimatedSprite2D.play("idle")
	add_to_group("enemies")

	
func play_attack() -> void:
	$AudioStreamPlayer.play()
