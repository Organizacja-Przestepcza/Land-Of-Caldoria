extends Enemy

func _init() -> void:
	mob_name = "spider"
	health = 5
	speed = randi_range(70,90)
	exp=5
	strength = 5

func _ready() -> void:
	super()
	sprite.play("idle")
	add_to_group("cave_enemies")
