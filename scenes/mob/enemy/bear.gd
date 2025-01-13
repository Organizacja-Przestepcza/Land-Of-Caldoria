extends Enemy

func _init() -> void:
	mob_name = "bear"
	dropped_item = ItemLoader.name("raw_steak")
	health = 40
	speed = 30
	exp = 20
	strength = 15
	bounce_force = 100

func _ready() -> void:
	super()
	$AnimatedSprite2D.play("idle")
	$ProgressBar.max_value = health
	add_to_group("enemies")

func handle_healthbar():
	$ProgressBar.visible = true
	$ProgressBar.value = health
