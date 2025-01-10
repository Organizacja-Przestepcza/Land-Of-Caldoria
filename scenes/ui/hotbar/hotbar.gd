extends Control
class_name Hotbar

@export var hotbarSize: int = 6
@export var slotSize: Vector2 = Vector2(64,64)
var selected_slot: InventorySlot:
	get:
		return selected_slot
	set(new_slot):
		if selected_slot:
			selected_slot.theme = null
			selected_slot.is_selected = false
		new_slot.theme = frame
		new_slot.is_selected = true
		selected_slot = new_slot
		
@onready var hotbar = $MarginContainer/Hotbar

func _ready() -> void:
	for i in hotbarSize:
		var slot = InventorySlot.new(InventorySlot.Type.MAIN, slotSize)
		slot.id = i
		slot.gui_input.connect(_on_slot_clicked.bind(slot))
		slot.theme_type_variation = &"InventorySlot"
		hotbar.add_child(slot)
	selected_slot=hotbar.get_child(0)
	selected_slot.theme_type_variation = &"InventorySlotSelected"
		
func _on_slot_clicked(event: InputEvent, slot) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		hotbar_slot_click.emit(slot.id)

signal hotbar_slot_click(index: int)

func select_slot(index: int):
	selected_slot.theme_type_variation = &"InventorySlot"
	selected_slot=hotbar.get_child(index)
	selected_slot.theme_type_variation = &"InventorySlotSelected"
	var held_item = get_held_item()
	item_selected.emit(held_item)
	SignalBus.selected_item_changed.emit(held_item)

signal item_selected(item: Item)

func get_held_item() -> Item:
	var inv_item = selected_slot.get_child(0) if selected_slot.get_child_count() > 0 else null
	if inv_item is InventoryItem:
		return inv_item.data
	return null
