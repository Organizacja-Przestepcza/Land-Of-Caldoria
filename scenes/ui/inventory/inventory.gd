extends Control

@export var invSize: int = 24
@export var slotSize: Vector2 = Vector2(64,64)

var itemsLoad = [
	"res://items/resource/wood/log.tres",
	"res://items/food/blueberry/blueberry.tres"
]

@onready var main = $HBoxContainer/VBoxContainer/Main
@onready var armor = $HBoxContainer/Armor



func _ready() -> void:
	for i in invSize:
		var slot = InventorySlot.new(InventorySlot.Type.MAIN, slotSize)
		slot.id = i
		slot.gui_input.connect(_on_slot_clicked.bind(slot))
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
	

func _on_slot_clicked(event: InputEvent, slot) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		emit_signal("inv_slot_click", slot.id)
			
signal inv_slot_click(index: int)
		
