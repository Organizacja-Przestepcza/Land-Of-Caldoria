class_name Hud
extends CanvasLayer

@onready var inventory = $Inventory
@onready var hotbar = $Hotbar/MarginContainer/Hotbar
@onready var main = $Inventory/HBoxContainer/VBoxContainer/Main
var player: Player
var hotbar_slot: InventorySlot
@onready var containers: Array[GridContainer] = [hotbar, main]

func _ready() -> void:
	player = get_parent()
	add_item(ItemDB.items["bandage"], 1)
	
func get_slot_under_mouse() -> InventorySlot:
	var mouse_pos = get_viewport().get_mouse_position()
	for container in containers:
		for slot in container.get_children():
			if slot is InventorySlot and slot.get_global_rect().has_point(mouse_pos):
				return slot
	return null  # No slot found under mouse

func find_free_space() -> int: ## deprecated in favor of find_available_slot
	for i in hotbar.get_child_count():
		if hotbar.get_child(i).get_child_count() == 0:
			return i
	for i in main.get_child_count():
		if main.get_child(i).get_child_count() == 0:
			return i + hotbar.get_child_count()
	return -1

func find_available_slot(itm: Item) -> InventorySlot:
	for container in containers:
		for slot in container.get_children():
			if slot.get_child_count() == 0:
				return slot
			else:
				var item: InventoryItem = slot.get_child(0)
				if item.data.name == itm.name and item.count < itm.max_stack_size:
					return slot
	return null

func add_item(item: Item, amount: int) -> void:
	var slot = find_available_slot(item)
	if slot == null:
		return
	if slot.get_child_count() == 0:
		var inv_item = InventoryItem.new(item, amount)
		slot.add_child(inv_item)
	else:
		var inv_item: InventoryItem = slot.get_child(0)
		var leftover = inv_item.add(amount)
		if leftover > 0:
			add_item(item, leftover)
		
func remove_item(slot: InventorySlot, amount: int) -> void:
	if slot.get_child_count() > 0:
		var item_at_index: InventoryItem = slot.get_child(0)
		item_at_index.remove(amount)

func consume(slot: InventorySlot, amount: int) -> void:
	if slot.get_child_count() > 0:
		var item: InventoryItem = slot.get_child(0)
		if item.data is Consumable:
			player.effect_from_item(item.data)
			item.remove(amount)

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and not event.echo:
			match event.physical_keycode:
				KEY_1: hotbar_slot=hotbar.get_child(0)
				KEY_2: hotbar_slot=hotbar.get_child(1)
				KEY_3: hotbar_slot=hotbar.get_child(2)
				KEY_4: hotbar_slot=hotbar.get_child(3)
				KEY_5: hotbar_slot=hotbar.get_child(4)
				KEY_6: hotbar_slot=hotbar.get_child(5)
		if event.is_action_pressed("drop_item"):
			remove_item(get_slot_under_mouse(), 1)
		elif event.is_action_pressed("interact"):
			consume(get_slot_under_mouse(), 1)
		elif event.is_action_pressed("gui_inventory"):
			inventory.visible = !inventory.visible
			if inventory.visible:
				hotbar.reparent(inventory.get_node("HBoxContainer/VBoxContainer"))
				inventory.get_node("HBoxContainer/VBoxContainer").move_child(hotbar, 0)
			else:
				hotbar.reparent(get_node("Hotbar/MarginContainer"))
