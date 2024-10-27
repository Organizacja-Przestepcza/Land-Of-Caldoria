class_name InventorySlot
extends PanelContainer

@export var type: Type
enum Type { MAIN, HEAD, ARMS, TORSO, LEGS, FEET }

func _init(t: Type, cms: Vector2) -> void:
	type = t
	custom_minimum_size = cms


func _can_drop_data(_at_position: Vector2, data: Variant):
	if data is InventoryItem:
		if type == Type.MAIN:
			if get_child_count() == 0:
				return true
			else:
				if type == data.get_parent().type:
					return true
			return get_child(0).data.type == data.data.type
		else:
			return data.data.type == type
	return false
	
func _drop_data(_at_position: Vector2, data: Variant):
	if get_child_count() > 0:
		var item = get_child(0)
		if item == data:
			return
		item.reparent(data.get_parent())
	data.reparent(self)
