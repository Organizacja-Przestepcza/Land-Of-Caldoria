extends Control

@export var invSize: int = 30
@export var slotSize: Vector2 = Vector2(64, 64)

@onready var chest = $HBoxContainer/ChestContainer/ChestInventory

func  _ready() -> void:
	for i in invSize:
		var slot = InventorySlot.new(InventorySlot.Type.MAIN, slotSize)
		slot.id = i
		slot.gui_input.connect(_on_slot_clicked.bind(slot))
		chest.add_child(slot)
		print("added slot: ", slot.id)

func _on_slot_clicked(event: InputEvent, slot) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		inv_slot_click.emit(slot.id)

signal inv_slot_click(index: int)
