extends Enemy

func _init() -> void:
	mob_name = "boar"
	dropped_item = ItemLoader.name("raw_steak")
	health = 30
	speed = 50
	exp = 10
	strength = 10
	bounce_force = 200

func _ready() -> void:
	super()
	$AnimatedSprite2D.play("idle")
	$ProgressBar.max_value = health
	add_to_group("enemies")

func play_chase() -> void:
	$AudioStreamPlayer.play()

func handle_healthbar():
	$ProgressBar.visible = true
	$ProgressBar.value = health
