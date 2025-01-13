extends Enemy

func _init() -> void:
	mob_name = "wolf"
	dropped_item = ItemLoader.name("raw_steak")
	health = 30
	speed = 90
	exp = 10
	strength = 10

func _ready() -> void:
	super()
	$AnimatedSprite2D.play("idle")
	$ProgressBar.max_value = health
	add_to_group("enemies")

func handle_healthbar():
	$ProgressBar.visible = true
	$ProgressBar.value = health
