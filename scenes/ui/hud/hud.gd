class_name Hud
extends CanvasLayer

@onready var inventory = $Inventory
@onready var hotbar = $Hotbar/MarginContainer/Hotbar
@onready var main = $Inventory/HBoxContainer/VBoxContainer/Main
var player: Player
var selected_slot: int

func _ready() -> void:
	player = get_parent()
	add_item("res://items/medicine/bandage.tres")

func find_free_space() -> int:
	for i in hotbar.get_child_count():
		if hotbar.get_child(i).get_child_count() == 0:
			return i
	for i in main.get_child_count():
		if main.get_child(i).get_child_count() == 0:
			return i + hotbar.get_child_count()
	return -1

func add_item(new_item: String) -> void:
	var index = find_free_space()
	var item = InventoryItem.new()
	item.init(load(new_item))
	if index in range(0,6):
		hotbar.get_child(index).add_child(item)
	elif index > 5:
		main.get_child(index - hotbar.get_child_count()).add_child(item)
		
func remove_item(index: int) -> void:
	var slot: InventorySlot
	if index in range(0,6):
		slot = hotbar.get_child(index)
	elif index > 5:
		slot = main.get_child(index - hotbar.get_child_count())
	if slot.get_child_count() > 0:
		var item_at_index = slot.get_child(0)
		item_at_index.queue_free()

func consume(index: int) -> void:
	var slot: InventorySlot
	if index in range(0,6):
		slot = hotbar.get_child(index)
	elif index > 5:
		slot = main.get_child(index - hotbar.get_child_count())
	if slot.get_child_count() > 0:
		var item: InventoryItem = slot.get_child(0)
		if item.data is Consumable:
			player.effect_from_item(item.data)
			item.queue_free()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("drop_item"):
		remove_item(selected_slot)
	if Input.is_action_just_pressed("interact"):
		consume(selected_slot)
	if Input.is_action_just_pressed("gui_inventory"):
		inventory.visible = !inventory.visible
		if inventory.visible:
			hotbar.reparent(inventory.get_node("HBoxContainer/VBoxContainer"))
			inventory.get_node("HBoxContainer/VBoxContainer").move_child(hotbar, 0)
		else:
			hotbar.reparent(get_node("Hotbar/MarginContainer"))

func _on_inventory_inv_slot_click(index: int) -> void:
	selected_slot = index + hotbar.get_child_count()

func _on_hotbar_slot_click(index: int) -> void:
	selected_slot = index
