extends Control

@export var hotbarSize: int = 6
@export var slotSize: Vector2 = Vector2(64,64)


func _ready() -> void:
	for i in hotbarSize:
		var slot = InventorySlot.new(InventorySlot.Type.MAIN, slotSize)
		%Hotbar.add_child(slot)
