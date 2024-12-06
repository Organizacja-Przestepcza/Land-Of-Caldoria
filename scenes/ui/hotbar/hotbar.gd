extends Control
class_name Hotbar

@export var hotbarSize: int = 6
@export var slotSize: Vector2 = Vector2(64,64)
var frame: Theme = preload("res://themes/frame.tres")
var selected_slot: InventorySlot
@onready var hotbar = $MarginContainer/Hotbar
func _ready() -> void:
	for i in hotbarSize:
		var slot = InventorySlot.new(InventorySlot.Type.MAIN, slotSize)
		slot.id = i
		slot.gui_input.connect(_on_slot_clicked.bind(slot))
		hotbar.add_child(slot)
	selected_slot=hotbar.get_child(0)
	selected_slot.theme = frame
		
func _on_slot_clicked(event: InputEvent, slot) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		emit_signal("hotbar_slot_click", slot.id)

signal hotbar_slot_click(index: int)

func select_slot(index: int):
	selected_slot.theme = null
	selected_slot=hotbar.get_child(index)
	selected_slot.theme = frame

func get_held_item() -> Item:
	var inv_item = selected_slot.get_child(0) #To mi się wywala, chyba trzeba sprawdzić czy istnieje selected item
	if inv_item is InventoryItem:
		return inv_item.data
	return
