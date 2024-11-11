class_name Hud
extends CanvasLayer

@onready var inventory = $Inventory
@onready var hotbar = $Hotbar/MarginContainer/Hotbar
@onready var main = $Inventory/HBoxContainer/VBoxContainer/Main
var player: Player
var hotbar_slot: InventorySlot
@onready var containers: Array[GridContainer] = [hotbar, main]
var frame: Theme = preload("res://themes/frame.tres")
var game_state: State

enum State {PLAYING, INVENTORY}

func _ready() -> void:
	player = get_parent()
	hotbar_slot=hotbar.get_child(0)
	hotbar_slot.theme = frame
	add_item(ItemDB.items["bandage"], 3)
	add_item(ItemDB.items["axe"], 1)
	add_item(ItemDB.items["pickaxe"], 1)

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
	if slot:
		if slot.get_child_count() > 0:
			var item_at_index: InventoryItem = slot.get_child(0)
			item_at_index.remove(amount)

func consume(slot: InventorySlot, amount: int) -> void:
	if slot:
		if slot.get_child_count() > 0:
			var item: InventoryItem = slot.get_child(0)
			if item.data is Consumable:
				player.effect_from_item(item.data)
				item.remove(amount)
 
func select_hotbar_slot(index: int):
	hotbar_slot.theme = null
	hotbar_slot=hotbar.get_child(index)
	hotbar_slot.theme = frame

func get_inventory_data() -> Dictionary:
	var inventory_data = {
		"hotbar": [],
		"main": []
	}
	for i in range(hotbar.get_child_count()):
		var slot: InventorySlot = hotbar.get_child(i)
		if slot.get_child_count() > 0:
			var item:InventoryItem = slot.get_child(0)
			inventory_data["hotbar"].append(item.data.resource_path)
		else:
			inventory_data["hotbar"].append(null)

	for i in range(main.get_child_count()):
		var slot:InventorySlot = main.get_child(i)
		if slot.get_child_count() > 0:
			var item:InventoryItem = slot.get_child(0)
			inventory_data["main"].append(item.data.resource_path)
		else:
			inventory_data["main"].append(null)
	print(inventory_data)
	return inventory_data

func load_inventory_data() -> void:
	var inventory_data = WorldData.load.inventory
	print(inventory_data)
	# Clear existing items in hotbar and main inventory
	for i in range(hotbar.get_child_count()):
		var slot: InventorySlot = hotbar.get_child(i)
		if slot.get_child_count() > 0:
			slot.get_child(0).queue_free()  # Remove current item

	for i in range(main.get_child_count()):
		var slot: InventorySlot = main.get_child(i)
		if slot.get_child_count() > 0:
			slot.get_child(0).queue_free()  # Remove current item

	# Load items into hotbar
	for i in range(len(inventory_data["hotbar"])):
		var item_path = inventory_data["hotbar"][i]
		if item_path != null:
			var item = InventoryItem.new()
			item.init(load(item_path))  # Load item from resource path
			hotbar.get_child(i).add_child(item)

	# Load items into main inventory
	for i in range(len(inventory_data["main"])):
		var item_path = inventory_data["main"][i]
		if item_path != null:
			var item = InventoryItem.new()
			item.init(load(item_path))  # Load item from resource path
			main.get_child(i).add_child(item)

func get_held_item() -> Item:
	var inv_item = hotbar_slot.get_child(0)
	if inv_item is InventoryItem:
		return inv_item.data
	return

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		match game_state:
			State.PLAYING:
				if event.is_action_pressed("attack", true):
					player.attack()
				elif event.is_action_pressed("drop_item"):
					remove_item(hotbar_slot,1)
				elif event.is_action_pressed("interact"):
					consume(hotbar_slot,1)
				elif event.is_action_pressed("gui_inventory"):
					inventory.visible = true
					hotbar.reparent(inventory.get_node("HBoxContainer/VBoxContainer"))
					inventory.get_node("HBoxContainer/VBoxContainer").move_child(hotbar, 0)
					game_state = State.INVENTORY
				elif event.pressed and not event.echo:
					match event.physical_keycode:
						KEY_1: select_hotbar_slot(0)
						KEY_2: select_hotbar_slot(1)
						KEY_3: select_hotbar_slot(2)
						KEY_4: select_hotbar_slot(3)
						KEY_5: select_hotbar_slot(4)
						KEY_6: select_hotbar_slot(5)
				elif event.is_action_pressed("ui_text_backspace"):
					print(self.position)
			State.INVENTORY:
				if event.is_action_pressed("drop_item"):
					remove_item(get_slot_under_mouse(),1)
				elif event.is_action_pressed("interact"):
					consume(get_slot_under_mouse(),1)
				elif event.is_action_pressed("gui_inventory"):
					inventory.visible = false
					hotbar.reparent(get_node("Hotbar/MarginContainer"))
					game_state = State.PLAYING
