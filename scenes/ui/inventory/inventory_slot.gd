class_name InventorySlot
extends PanelContainer

@export var type: Type
enum Type { MAIN, HEAD, ARMS, TORSO, LEGS, FEET }

func _init(t: Type, cms: Vector2) -> void:
	type = t
	custom_minimum_size = cms


func _can_drop_data(_at_position: Vector2, item: Variant):
	if item is InventoryItem:
		return item.data.slot == type
	return false
	
func _drop_data(_at_position: Vector2, dropped_item: Variant):
	if get_child_count() > 0:
		var current_item = get_child(0)
		if current_item == dropped_item:
			return
		current_item.reparent(dropped_item.get_parent())
	dropped_item.reparent(self)
