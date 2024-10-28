extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var variants: Array = []
	
	for tree in $".".get_children():
		variants.append(tree)
	var random_variant = variants.pick_random()
	random_variant.visible = true
	var collision      = random_variant.get_child(1)  # Assuming second child is CollisionShape2D
	if collision is CollisionPolygon2D:
		collision.disabled = false  # Enable the collision


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
