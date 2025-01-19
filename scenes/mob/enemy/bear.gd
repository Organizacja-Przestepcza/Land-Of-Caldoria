extends Enemy

func _init() -> void:
	mob_name = "bear"
	dropped_item = ItemLoader.name("raw_steak")
	health = 40
	speed = randi_range(25,40)
	exp = 20
	strength = 15
	bounce_force = 100

func _ready() -> void:
	super()
	sprite.play("idle")
	add_to_group("enemies")
