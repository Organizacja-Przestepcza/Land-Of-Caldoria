extends Node2D

func _ready() -> void:
	var variants: Array = []
	
	for object in $".".get_children():
		variants.append(object)
	var random_variant = variants.pick_random()
	random_variant.visible = true
	var collision = random_variant.get_child(1)
	if collision is CollisionObject2D:
		collision.disabled = false  # Enable the collision
