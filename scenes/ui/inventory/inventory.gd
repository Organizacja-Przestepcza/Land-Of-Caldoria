extends Control

@export var invSize: int = 24
@export var slotSize: Vector2 = Vector2(64,64)

var itemsLoad = [
	"res://items/resource/wood/log.tres",
	"res://items/food/blueberry/blueberry.tres"
]


func _ready() -> void:
	var main = $HBoxContainer/VBoxContainer/Main
	var armor = $HBoxContainer/Armor
	for i in invSize:
		var slot = InventorySlot.new(InventorySlot.Type.MAIN, slotSize)
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
	
	for i in itemsLoad.size():
		var item = InventoryItem.new()
		item.init(load(itemsLoad[i]))
		main.get_child(i).add_child(item)
