extends Area2D
class_name InteractableArea

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.nearest_interactable = self

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		if body.nearest_interactable == self:
			body.nearest_interactable = null
