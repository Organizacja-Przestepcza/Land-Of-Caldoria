extends Control
class_name Hotbar

@export var hotbarSize: int = 6
@export var slotSize: Vector2 = Vector2(64,64)
var selected_slot: InventorySlot:
	get:
		return selected_slot
	set(new_slot):
		if selected_slot:
			selected_slot.theme_type_variation = &"InventorySlot"
			selected_slot.is_selected = false
		new_slot.theme_type_variation = &"InventorySlotSelected"
		new_slot.is_selected = true
		selected_slot = new_slot
		
@onready var hotbar = $MarginContainer/Hotbar
var selected_slot_number: int:
	get:
		return selected_slot_number
	set(slot_number):
		selected_slot_number = (slot_number+6) %6
		selected_slot=hotbar.get_child(selected_slot_number)
		
func _ready() -> void:
	for i in hotbarSize:
		var slot = InventorySlot.new(InventorySlot.Type.MAIN, slotSize)
		slot.id = i
		slot.gui_input.connect(_on_slot_clicked.bind(slot))
		slot.theme_type_variation = &"InventorySlot"
		hotbar.add_child(slot)
	selected_slot_number=0

func _on_slot_clicked(event: InputEvent, slot) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		hotbar_slot_click.emit(slot.id)

signal hotbar_slot_click(index: int)

func select_slot(index: int):
	selected_slot_number=index
	var held_item = get_held_item()
	item_selected.emit(held_item)
	SignalBus.selected_item_changed.emit(held_item)

signal item_selected(item: Item)

func select_next_slot():
	select_slot(selected_slot_number +1)
	
func select_previous_slot():
	select_slot(selected_slot_number -1)
func get_held_item() -> Item:
	var inv_item = selected_slot.get_child(0) if selected_slot.get_child_count() > 0 else null
	if inv_item is InventoryItem:
		return inv_item.data
	return null
func get_held_inventory_item() -> InventoryItem:
	var inv_item = selected_slot.get_child(0) if selected_slot.get_child_count() > 0 else null
	return inv_item
