extends RigidBody2D
class_name Bullet

@export var bullet_speed: float = 500.0
@export var lifetime: float = 3.0
@export var gravity: float = 0

var direction: Vector2 = Vector2(0, -1)

func _ready():
	gravity_scale = gravity
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func set_direction_towards(target_position: Vector2):
	direction = (target_position - global_position).normalized()
	linear_velocity = direction * bullet_speed
