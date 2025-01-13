extends Node2D
class_name LootBag

var items: Dictionary = {}

func _ready() -> void:
	if WorldData.player.nearest_interactable is LootBag:
		WorldData.player.nearest_interactable.add_items(items)
		queue_free()

func add_items(new_items: Dictionary):
	for item in new_items:
		if items.has(item):
			items[item] += 1
		else:
			items[item] = new_items[item]
