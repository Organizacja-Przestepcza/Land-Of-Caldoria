extends Node2D
class_name LootChest

var items: Array

func _ready() -> void:
	for i in randi_range(2,5):
		items.append(ItemLoader.random_item())
