extends ItemList
class_name HintLegend

@onready var hints: ItemList = $"."

func _ready() -> void:
	SignalBus.selected_item_changed.connect(add_hint_for_item)

func add_hint_for_item(item:Item)-> void:
	hints.clear()
	var input_use: InputEvent = InputMap.action_get_events("LC_use").filter(func(action): return action is InputEventKey or action is InputEventMouseButton).front()
	var input_inventory: InputEvent = InputMap.action_get_events("LC_inventory").filter(func(action): return action is InputEventKey or action is InputEventMouseButton).front()
	hints.add_item("%s- inventory"%input_inventory.as_text().get_slice("(",0))
	if item is Consumable:
		hints.add_item("%s- consume"%input_use.as_text().get_slice("(",0))
	elif item is Tool:
		hints.add_item("%s- use"%input_use.as_text().get_slice("(",0))
	elif item is Ranged:
		var input_ammo: InputEvent = InputMap.action_get_events("LC_switch_ammo").filter(func(action): return action is InputEventKey or action is InputEventMouseButton).front()
		hints.add_item("%s- shoot"%input_use.as_text().get_slice("(",0))
		hints.add_item("%s- change ammo"%input_ammo.as_text().get_slice("(",0))
	if item:
		var input_drop_item: InputEvent = InputMap.action_get_events("LC_drop_item").filter(func(action): return action is InputEventKey or action is InputEventMouseButton).front()
		hints.add_item("%s- drop item"%input_drop_item.as_text().get_slice("(",0))
