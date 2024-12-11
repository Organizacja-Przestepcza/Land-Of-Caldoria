extends Interface
class_name AmmoSelector

@onready var ammo_list: ItemList = $MarginContainer/VBoxContainer/AmmoList
@onready var hotbar: Hotbar = %Hotbar

var current_ammo: Item

func open():
	super()
	var held_item = hotbar.get_held_item()
	if held_item is Ranged:
		if current_ammo not in held_item.ammo_list:
			current_ammo = held_item.ammo_list.pick_random()
		for ammo: Item in held_item.ammo_list:
			ammo_list.add_item(ammo.name)
			ammo_list.set_item_metadata(ammo_list.item_count-1, ammo)
	else:
		current_ammo = null


func _on_ammo_list_item_selected(index: int) -> void:
	var ammo = ammo_list.get_item_metadata(index)
	if ammo is Item:
		current_ammo = ammo
