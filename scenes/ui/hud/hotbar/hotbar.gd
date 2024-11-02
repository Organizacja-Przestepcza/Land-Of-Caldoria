extends Control

@export var hotbarSize: int = 6
@export var slotSize: Vector2 = Vector2(64,64)

var itemsLoad = [
	"res://items/resource/wood/log.tres",
	"res://items/food/blueberry/blueberry.tres"
]


func _ready() -> void:
	var main = $MarginContainer/Hotbar
	for i in hotbarSize:
		var slot = InventorySlot.new(InventorySlot.Type.MAIN, slotSize)
		%Hotbar.add_child(slot)
	for i in itemsLoad.size():
		var item = InventoryItem.new()
		item.init(load(itemsLoad[i]))
		main.get_child(i).add_child(item)
