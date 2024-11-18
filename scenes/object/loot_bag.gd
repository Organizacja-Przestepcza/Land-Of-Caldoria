extends Node2D
class_name LootBag

var items: Dictionary = {}

func _ready() -> void:
	$DetectionArea.body_entered.connect(_on_detection_area_body_entered)
	$DetectionArea.body_exited.connect(_on_detection_area_body_exited)

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body is Player:
		body.get_node("Hud").lootbag_in_range = self

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body is Player:
		var hud: Hud = body.get_node("Hud")
		if hud.lootbag_in_range == self:
			hud.lootbag_in_range = null
