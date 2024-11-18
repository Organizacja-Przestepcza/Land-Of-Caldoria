class_name Hud
extends CanvasLayer

@onready var inventory = $Inventory
@onready var hotbar = $Hotbar/MarginContainer/Hotbar
@onready var main = $Inventory/HBoxContainer/VBoxContainer/Main
@onready var pause_menu: PauseMenu = $"../PauseMenu"
@onready var building_menu: BuildMenu = $BuildingMenu

@onready var crafting: Crafting = $Crafting

var lootbag_in_range: LootBag

@onready var build_manager: BuildManager = $"../../BuildManager"
var inventory_keys = ["hotbar", "main", "armor"]
var player: Player
var hotbar_slot: InventorySlot
@onready var containers: Array[GridContainer] = [hotbar, main]
var frame: Theme = preload("res://themes/frame.tres")
var state: State = State.PLAYING

enum State {PLAYING, INVENTORY}

func _ready() -> void:
	player = get_parent()
	hotbar_slot=hotbar.get_child(0)
	hotbar_slot.theme = frame
	add_item(ItemLoader.name("bandage"), 3)
	add_item(ItemLoader.name("axe"), 1)
	add_item(ItemLoader.name("pickaxe"), 1)
	add_item(ItemLoader.name("hammer"), 1)

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

func find_item(itm: Item) -> InventorySlot:
	for container in containers:
		for slot in container.get_children():
			if not slot.get_child_count() == 0:
				var item: InventoryItem = slot.get_child(0)
				if item.data.name == itm.name:
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
		
func remove_item_in_slot(slot: InventorySlot, amount: int) -> int: #returns the number of not removed items
	if slot:
		if slot.get_child_count() > 0:
			var item_at_index: InventoryItem = slot.get_child(0)
			var leftover: int = item_at_index.remove(amount)
			return leftover
	return 0

func drop_item_in_slot(slot: InventorySlot, amount: int):
	if slot:
		if slot.get_child_count() > 0:
			var item: InventoryItem = slot.get_child(0)
			var lootbag_tscn = load("res://scenes/object/loot_bag.tscn")
			var lootbag: LootBag = lootbag_tscn.instantiate()
			lootbag.position = player.position
			lootbag.items[item.data] = amount
			player.get_parent().add_child(lootbag)
			item.remove(amount)

func remove_item(itm: Item, amount: int):
	while amount > 0:
		var slot: InventorySlot = find_item(itm)
		if slot:
			var leftover = remove_item_in_slot(slot, amount)
			amount = leftover

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
		"main": [],
		"armor": []
	}
	#var inventory_keys = inventory_data.keys()
	for c in range(containers.size()):
		for i in range(containers[c].get_child_count()):
			var slot: InventorySlot = containers[c].get_child(i)
			if slot.get_child_count() > 0:
				var item:InventoryItem = slot.get_child(0)
				
				inventory_data[inventory_keys[c]].append([item.data.name,item.count])
			else:
				inventory_data[inventory_keys[c]].append(null)
	return inventory_data

func load_inventory_data() -> void:
	var inventory_data = WorldData.load.inventory
	print(inventory_data)
	# Clear existing items in hotbar and main inventory
	clean_inventory()
	
	#var inventory_keys = inventory_data.keys()
	print(inventory_keys)
	for c in range(containers.size()):
		for i in range(containers[c].get_child_count()):
			var item_path = inventory_data[inventory_keys[c]][i]
			if item_path != null:
				var item = InventoryItem.new(ItemLoader.items[str(item_path[0]).to_lower().replace(" ","_")], item_path[1])
				containers[c].get_child(i).add_child(item)

func clean_inventory() -> void:
	for c in containers:
		for i in range(c.get_child_count()):
			var slot: InventorySlot = c.get_child(i)
			if slot.get_child_count() > 0:
				slot.get_child(0).queue_free()  # Remove current item
			
func get_held_item() -> Item:
	var inv_item = hotbar_slot.get_child(0)
	if inv_item is InventoryItem:
		return inv_item.data
	return


func use_item() -> void:
	var held_item = get_held_item()
	if held_item is Consumable:
		consume(hotbar_slot,1)
	elif held_item == ItemLoader.name("hammer"):
		build_manager.build()
	elif held_item is Tool:
		attack(held_item)

func attack(tool: Tool):
	var victim = await player.attack()
	if victim is Mob:
		if victim.take_damage(tool.damage) and victim.dropped_item:
			add_item(victim.dropped_item, 1)
	if victim is Destroyable:
		if victim.required_tool == get_held_item() or victim.required_tool == null:
			if victim.take_damage(tool.damage) and victim.dropped_item:
				add_item(victim.dropped_item, 1)

func pickup_loot_bag():
	if lootbag_in_range:
		for key in lootbag_in_range.items.keys():
			add_item(key,lootbag_in_range.items[key])
		lootbag_in_range.queue_free()

func open_build_menu():
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		match state:
			State.PLAYING:
				if event.is_action_pressed("use", true):
					use_item()
				elif event.is_action_pressed("drop_item"):
					drop_item_in_slot(hotbar_slot,1)
				elif event.is_action_pressed("interact"):
					pickup_loot_bag()
				elif event.is_action_pressed("build_menu"):
					building_menu.open()
					state = State.INVENTORY
				elif event.is_action_pressed("gui_inventory"):
					inventory.open()
					state = State.INVENTORY
				elif event.is_action_pressed("crafting_menu"):
					crafting.open()
					state = State.INVENTORY
				elif event.is_action_pressed("ui_text_backspace"):
					print(self.position)
				elif event.pressed and not event.echo:
					match event.physical_keycode:
						KEY_1: select_hotbar_slot(0)
						KEY_2: select_hotbar_slot(1)
						KEY_3: select_hotbar_slot(2)
						KEY_4: select_hotbar_slot(3)
						KEY_5: select_hotbar_slot(4)
						KEY_6: select_hotbar_slot(5)
			State.INVENTORY:
				if event.is_action_pressed("drop_item"):
					drop_item_in_slot(get_slot_under_mouse(),1)
				elif event.is_action_pressed("use"):
					consume(get_slot_under_mouse(),1)
				elif event.is_action_pressed("crafting_menu"):
					close_menus()
				elif event.is_action_pressed("build_menu"):
					close_menus()
				elif event.is_action_pressed("gui_inventory") or event.is_action_pressed("ui_cancel"):
					close_menus()

func close_menus():
	inventory.close()
	crafting.close()
	building_menu.close()
	state = State.PLAYING

func inventory_to_list() -> Dictionary:
	var list: Dictionary
	for c in containers:
		for slot in c.get_children():
			if !slot.get_child_count():
				return list
			var item:InventoryItem = slot.get_child(0)
			if item and item.count > 0:
				list[item.data] = item.count
	return list
