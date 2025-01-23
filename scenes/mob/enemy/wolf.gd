extends Enemy

func _init() -> void:
	mob_name = "wolf"
	dropped_item = ItemLoader.name("raw_steak")
	health = 30 + WorldData.difficulty * 5
	speed = randi_range(80,100)
	exp = 10 + WorldData.difficulty * 2
	strength = 10 + WorldData.difficulty * 2

func _ready() -> void:
	super()
	sprite.play("idle")
	add_to_group("enemies")
