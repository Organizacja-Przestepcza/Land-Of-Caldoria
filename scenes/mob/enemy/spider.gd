extends Enemy

func _init() -> void:
	mob_name = "spider"
	health = 5
	speed = 80
	exp=5
	strength = 5

func _ready() -> void:
	super()
	$AnimatedSprite2D.play("idle")
	add_to_group("enemies")
