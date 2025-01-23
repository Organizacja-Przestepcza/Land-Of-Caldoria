extends Enemy

func _init() -> void:
	mob_name = "bat"
	health = 10 + WorldData.difficulty * 5
	speed = randi_range(60,80)
	strength = 5 + WorldData.difficulty * 2
	exp = 5 + WorldData.difficulty * 2

func _ready() -> void:
	super()
	add_to_group("cave_enemies")

func attack() -> void:
	player.hit(strength)
	var damage = strength
	SignalBus.player_attacked.emit(mob_name,damage)

func _on_detection_area_body_entered(body: Node2D) -> void:
	chase_player = true
	$AnimatedSprite2D.play("walk")

func _on_detection_area_body_exited(body: Node2D) -> void:
	chase_player = false
	
