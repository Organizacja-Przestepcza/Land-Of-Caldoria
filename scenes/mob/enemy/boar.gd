extends Enemy

func _init() -> void:
	mob_name = "boar"
	dropped_item = ItemLoader.name("raw_steak")
	health = 30 + WorldData.difficulty * 5
	speed = randi_range(45,60)
	exp = 10 + WorldData.difficulty * 2
	strength = 10 + WorldData.difficulty * 2
	bounce_force = 200

func _ready() -> void:
	super()
	$AnimatedSprite2D.play("idle")
	add_to_group("enemies")

func play_chase() -> void:
	$AudioStreamPlayer.play()
