extends RigidBody2D
class_name Bullet

@export var bullet_speed: float = 500.0
@export var lifetime: float = 3.0
@export var gravity: float = 0
@export var damage: int = 1

var direction: Vector2 = Vector2(0, -1)

func _ready():
	contact_monitor = true
	max_contacts_reported = 1
	gravity_scale = gravity
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func set_direction_towards(target_position: Vector2):
	direction = (target_position - global_position).normalized()
	linear_velocity = direction * bullet_speed


func _on_body_entered(body: Node) -> void:
	hit.emit(body, damage)
	queue_free()

signal hit(body: Node, damage: int)
