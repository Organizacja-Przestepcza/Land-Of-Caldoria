extends Interface
class_name AmmoSelector

@onready var ammo_list: ItemList = $MarginContainer/VBoxContainer/AmmoList

var weapon_ammo: Dictionary
var current_weap: Item

func update_ammo_list_for_item(item: Item):
	ammo_list.clear()
	if item is Ranged:
		current_weap = item
		for ammo: Item in item.ammo_list:
			ammo_list.add_item(ammo.name)
			ammo_list.set_item_metadata(ammo_list.item_count-1, ammo)


func _on_ammo_list_item_selected(index: int) -> void:
	var ammo = ammo_list.get_item_metadata(index)
	if ammo is Item:
		weapon_ammo[current_weap] = ammo

func get_current_ammo() -> Item:
	if current_weap is Ranged:
		var current_ammo = weapon_ammo.get_or_add(current_weap, current_weap.ammo_list.pick_random())
		return current_ammo
	return null
