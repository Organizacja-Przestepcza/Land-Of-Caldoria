extends Control

@export var hotbarSize: int = 6
@export var slotSize: Vector2 = Vector2(64,64)


func _ready() -> void:
	var main = $MarginContainer/Hotbar
	for i in hotbarSize:
		var slot = InventorySlot.new(InventorySlot.Type.MAIN, slotSize)
		slot.id = i
		slot.gui_input.connect(_on_slot_clicked.bind(slot))
		%Hotbar.add_child(slot)
		
func _on_slot_clicked(event: InputEvent, slot) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		emit_signal("hotbar_slot_click", slot.id)

signal hotbar_slot_click(index: int)
