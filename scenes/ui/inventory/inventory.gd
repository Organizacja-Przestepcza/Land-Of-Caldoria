extends Control
class_name Inventory
@export var inv_size: int = 24
@export var slot_size: Vector2 = Vector2(64,64)
@onready var player: Player = %Player
@onready var hotbar: GridContainer = %Hotbar/MarginContainer/Hotbar
@onready var main: GridContainer = $HBoxContainer/VBoxContainer/Main
@onready var backpack: GridContainer = $HBoxContainer/Backpack
@onready var armor: GridContainer = $HBoxContainer/Armor
@onready var hotbar_container = %Hotbar/MarginContainer
@onready var containers: Array[GridContainer] = [hotbar, main]
var inventory_keys = ["hotbar", "main", "armor"]
var lootbag_tscn = preload("res://scenes/object/loot_bag.tscn")
var torso_slot: InventorySlot

func _ready() -> void:
	
	for i in inv_size:
		var slot = InventorySlot.new(InventorySlot.Type.MAIN, slot_size)
		slot.id = i
		slot.theme_type_variation = &"InventorySlot"
		main.add_child(slot)
	for i in 14:
		var slot = InventorySlot.new(InventorySlot.Type.MAIN, slot_size)
		slot.id = i
		slot.theme_type_variation = &"InventorySlot"
		slot.is_backpack = true
		backpack.add_child(slot)
	
	var head_slot = InventorySlot.new(InventorySlot.Type.HEAD, slot_size)
	torso_slot = InventorySlot.new(InventorySlot.Type.TORSO, slot_size)
	torso_slot.is_torso = true
	var arms_slot = InventorySlot.new(InventorySlot.Type.ARMS, slot_size)
	var legs_slot = InventorySlot.new(InventorySlot.Type.LEGS, slot_size)
	var feet_slot = InventorySlot.new(InventorySlot.Type.FEET, slot_size)
	head_slot.theme_type_variation = &"ArmorSlotHead"
	torso_slot.theme_type_variation = &"ArmorSlotTorso"
	arms_slot.theme_type_variation = &"ArmorSlotArms"
	legs_slot.theme_type_variation = &"ArmorSlotLegs"
	feet_slot.theme_type_variation = &"ArmorSlotFeet"
	armor.add_child(head_slot)
	armor.add_child(torso_slot)
	armor.add_child(arms_slot)
	armor.add_child(legs_slot)
	armor.add_child(feet_slot)
	
	add_item(ItemLoader.name("bandage"), 3)
	add_item(ItemLoader.name("axe"), 1)
	add_item(ItemLoader.name("pickaxe"), 1)
	add_item(ItemLoader.name("hammer"), 1)
	
	SignalBus.torso_item.connect(wear_backpack)

func wear_backpack():
	print("drop")
	if torso_slot.get_child_count() > 0:
		print("in")
		var inv_item = torso_slot.get_child(0) as InventoryItem
		backpack.visible = inv_item.data == ItemLoader.name("backpack")
	else:
		backpack.hide()

func open():
	hotbar.reparent(get_node("HBoxContainer/VBoxContainer"))
	$HBoxContainer/VBoxContainer.move_child(hotbar, 0)

func close():
	hotbar.reparent(hotbar_container)

func find_available_slot(itm: Item) -> InventorySlot:
	if itm:
		for container in containers:
			for slot in container.get_children():
				if slot.get_child_count() == 0:
					return slot
				else:
					var item: InventoryItem = slot.get_child(0)
					if item.data.name == itm.name and item.count < itm.max_stack_size:
						return slot
	return null

func get_armor():
	var armor_array: Array
	for slot: InventorySlot in armor.get_children():
		if slot.get_child_count() > 0:
			var item: InventoryItem = slot.get_child(0)
			if item.data is Armor:
				armor_array.push_back(item.data)
	return armor_array

func find_item(itm: Item) -> InventorySlot:
	if not itm:
		push_warning("this item doesnt exist")
		return null
	for container in containers:
		for slot in container.get_children():
			if not slot.get_child_count() == 0:
				var item: InventoryItem = slot.get_child(0)
				if item.data.name == itm.name and item.count > 0:
					return slot
	return null

func add_item(item: Item, amount: int) -> void:
	var slot = find_available_slot(item)
	if slot == null:
		return
	if slot.get_child_count() == 0 and amount > item.max_stack_size:
		var inv_item = InventoryItem.new(item, item.max_stack_size)
		slot.add_child(inv_item)
		add_item(item,amount-item.max_stack_size)
		return
	elif slot.get_child_count() == 0:
		var inv_item = InventoryItem.new(item, amount)
		slot.add_child(inv_item)
	else:
		var inv_item: InventoryItem = slot.get_child(0)
		var leftover = inv_item.add(amount)
		if leftover > 0:
			add_item(item, leftover)
			
func remove_item(itm: Item, amount: int):
	var loop = 0
	while amount > 0:
		var slot: InventorySlot = find_item(itm)
		if slot:
			var leftover = remove_item_in_slot(slot, amount)
			if amount == leftover and loop > 5:
				printerr("infinite loop detected") # PROPER FIX REQUIRED
				break
			amount = leftover
			loop+=1
		
func remove_item_in_slot(slot: InventorySlot, amount: int) -> int: #returns the number of not removed items
	if slot.get_child_count() > 0:
		var item_at_index: InventoryItem = slot.get_child(0)
		var leftover: int = item_at_index.remove(amount)
		return leftover
	return 0

func drop_item_in_slot(slot: InventorySlot, amount: int):
	if slot.get_child_count() > 0:
		var item: InventoryItem = slot.get_child(0)
		var lootbag: LootBag = lootbag_tscn.instantiate()
		lootbag.position = player.position
		lootbag.items[item.data] = amount
		player.get_parent().add_child(lootbag)
		item.remove(amount)


func get_data() -> Dictionary:
	var inventory_data = {}
	
	for c in range(containers.size()):
		inventory_data.get_or_add(inventory_keys[c], [])
		for i in range(containers[c].get_child_count()):
			var slot: InventorySlot = containers[c].get_child(i)
			if slot.get_child_count() > 0:
				var item:InventoryItem = slot.get_child(0)
				
				inventory_data[inventory_keys[c]].append([item.data.name,item.count])
			else:
				inventory_data[inventory_keys[c]].append(null)
	return inventory_data

func load_data() -> void:
	var inventory_data = WorldData.load.inventory
	# Clear existing items in hotbar and main inventory
	clean()
	
	#var inventory_keys = inventory_data.keys()
	for c in range(containers.size()):
		for i in range(containers[c].get_child_count()):
			var item_path = inventory_data[inventory_keys[c]][i]
			if item_path != null:
				var item = InventoryItem.new(ItemLoader.name(str(item_path[0])), item_path[1])
				containers[c].get_child(i).add_child(item)

func clean() -> void:
	for c in containers:
		for i in range(c.get_child_count()):
			var slot: InventorySlot = c.get_child(i)
			if slot.get_child_count() > 0:
				slot.get_child(0).queue_free()  # Remove current item
			
func to_list() -> Dictionary:
	var list: Dictionary
	for c in containers:
		for slot in c.get_children():
			if !slot.get_child_count():
				continue
			var item:InventoryItem = slot.get_child(0)
			if item and item.count > 0:
				if list.has(item.data):
					list[item.data] += item.count
				else:
					list[item.data] = item.count
	return list
	
func get_item_in_slot(slot: InventorySlot) -> Item:
	if slot.get_child_count() > 0:
		return slot.get_child(0).data
	return
