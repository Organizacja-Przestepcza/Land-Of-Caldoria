extends Interface
class_name Inventory
@export var invSize: int = 24
@export var slotSize: Vector2 = Vector2(64,64)
@onready var player: Player = %Player
@onready var hotbar: GridContainer = %Hotbar/MarginContainer/Hotbar
@onready var main = $HBoxContainer/VBoxContainer/Main
@onready var armor = $HBoxContainer/Armor
@onready var containers: Array[GridContainer] = [hotbar, main]
var inventory_keys = ["hotbar", "main", "armor"]

func _ready() -> void:
	
	for i in invSize:
		var slot = InventorySlot.new(InventorySlot.Type.MAIN, slotSize)
		slot.id = i
		main.add_child(slot)
		
	var headSlot = InventorySlot.new(InventorySlot.Type.HEAD, slotSize)
	var torsoSlot = InventorySlot.new(InventorySlot.Type.TORSO, slotSize)
	var armsSlot = InventorySlot.new(InventorySlot.Type.ARMS, slotSize)
	var legsSlot = InventorySlot.new(InventorySlot.Type.LEGS, slotSize)
	var feetSlot = InventorySlot.new(InventorySlot.Type.FEET, slotSize)
	
	armor.add_child(headSlot)
	armor.add_child(torsoSlot)
	armor.add_child(armsSlot)
	armor.add_child(legsSlot)
	armor.add_child(feetSlot)
	
	add_item(ItemLoader.name("bandage"), 3)
	add_item(ItemLoader.name("axe"), 1)
	add_item(ItemLoader.name("pickaxe"), 1)
	add_item(ItemLoader.name("hammer"), 1)
	
	
func open():
	super()
	hotbar.reparent(get_node("HBoxContainer/VBoxContainer"))
	$HBoxContainer/VBoxContainer.move_child(hotbar, 0)

func close():
	super()
	hotbar.reparent(%Hotbar/MarginContainer)

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
	if amount > item.max_stack_size:
		pass
	if slot.get_child_count() == 0 and amount > item.max_stack_size:
		var inv_item = InventoryItem.new(item, item.max_stack_size)
		slot.add_child(inv_item)
		add_item(item,amount-item.max_stack_size)
	elif slot.get_child_count() == 0:
		var inv_item = InventoryItem.new(item, amount)
		slot.add_child(inv_item)
	else:
		var inv_item: InventoryItem = slot.get_child(0)
		var leftover = inv_item.add(amount)
		if leftover > 0:
			add_item(item, leftover)
			
func remove_item(itm: Item, amount: int):
	while amount > 0:
		var slot: InventorySlot = find_item(itm)
		if slot:
			var leftover = remove_item_in_slot(slot, amount)
			amount = leftover
		
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


func get_data() -> Dictionary:
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

func load_data() -> void:
	var inventory_data = WorldData.load.inventory
	print(inventory_data)
	# Clear existing items in hotbar and main inventory
	clean()
	
	#var inventory_keys = inventory_data.keys()
	print(inventory_keys)
	for c in range(containers.size()):
		for i in range(containers[c].get_child_count()):
			var item_path = inventory_data[inventory_keys[c]][i]
			if item_path != null:
				var item = InventoryItem.new(ItemLoader.items[str(item_path[0]).to_lower().replace(" ","_")], item_path[1])
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
				return list
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
