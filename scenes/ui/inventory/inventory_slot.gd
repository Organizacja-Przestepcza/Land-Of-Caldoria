class_name InventorySlot
extends PanelContainer

@export var type: Type
@export var id: int
var is_selected: bool = false
var is_torso: bool = false
var is_backpack: bool = false

enum Type { MAIN, HEAD, ARMS, TORSO, LEGS, FEET }

func _init(t: Type, cms: Vector2) -> void:
	type = t
	custom_minimum_size = cms


func _can_drop_data(_at_position: Vector2, item: Variant) -> bool:
	if item is InventoryItem:
		if type == Type.MAIN:
			return true
		return item.data.slot == type 
	return false
	
func _drop_data(_at_position: Vector2, dropped_item: Variant) -> void:
	if dropped_item is InventoryItem:
		if get_child_count() > 0:
			var current_item: InventoryItem = get_child(0)
			if current_item == dropped_item:
				return
			if current_item.data == dropped_item.data:
				var amount_left = current_item.add(dropped_item.count)
				dropped_item.remove(dropped_item.count - amount_left)
				return
			current_item.reparent(dropped_item.get_parent())
		elif dropped_item.get_parent().is_selected:
			SignalBus.selected_item_changed.emit(null)
		dropped_item.reparent(self)
		if is_selected:
			SignalBus.selected_item_changed.emit(dropped_item.data)
		SignalBus.torso_item.emit()
