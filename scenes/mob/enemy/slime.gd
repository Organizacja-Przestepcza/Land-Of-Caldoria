extends Enemy

func _ready() -> void:
	super()
	mob_name = "Slime"
	health = 20
	speed = 80
	exp = 3
	strength = 5
	$AnimatedSprite2D.play("idle")
	$ProgressBar.max_value = health
	$ProgressBar.value = health

func handle_healthbar():
	$ProgressBar.visible = true
	$ProgressBar.value = health
	
func play_attack() -> void:
	$AudioStreamPlayer.play()
