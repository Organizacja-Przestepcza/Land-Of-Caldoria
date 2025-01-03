extends ItemList
class_name HintLegend

@onready var hints: ItemList = $"."

func add_hint_for_item(item:Item)-> void:
	hints.clear()
	var input_use: InputEvent = InputMap.action_get_events("LC_use").filter(func(action): return action is InputEventKey or action is InputEventMouseButton).front()
	
	if item is Consumable:
		hints.add_item("%s - consume"%input_use.as_text().get_slice("(",0))
	elif item is Tool:
		hints.add_item("%s - use"%input_use.as_text().get_slice("(",0))
	elif item is Ranged:
		var input_ammo: InputEvent = InputMap.action_get_events("LC_switch_ammo").filter(func(action): return action is InputEventKey or action is InputEventMouseButton).front()
		hints.add_item("%s - shoot"%input_use.as_text().get_slice("(",0))
		hints.add_item("%s - change ammo"%input_ammo.as_text().get_slice("(",0))
