extends Enemy

func _init() -> void:
	mob_name = "spider"
	health = 5 + WorldData.difficulty * 5
	speed = randi_range(70,90)
	exp = 5 + WorldData.difficulty * 2
	strength = 5 + WorldData.difficulty * 2

func _ready() -> void:
	super()
	sprite.play("idle")
	add_to_group("cave_enemies")
