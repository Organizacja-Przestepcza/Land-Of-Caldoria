extends CanvasLayer

var invSize: int = 24
var slotSize: Vector2 = Vector2(64,64)
var itemsLoad = [
	"res://items/resource/wood/log.tres"
]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in invSize:
		var slot = InventorySlot.new(InventorySlot.Type.MAIN, slotSize)
		$Main.add_child(slot)
	var headSlot = InventorySlot.new(InventorySlot.Type.HEAD, slotSize)
	var torsoSlot = InventorySlot.new(InventorySlot.Type.TORSO, slotSize)
	var armsSlot = InventorySlot.new(InventorySlot.Type.ARMS, slotSize)
	var legsSlot = InventorySlot.new(InventorySlot.Type.LEGS, slotSize)
	var feetSlot = InventorySlot.new(InventorySlot.Type.FEET, slotSize)
	$Armor.add_child(headSlot)
	$Armor.add_child(torsoSlot)
	$Armor.add_child(armsSlot)
	$Armor.add_child(legsSlot)
	$Armor.add_child(feetSlot)
	for i in itemsLoad.size():
		var item = InventoryItem.new()
		item.init(load(itemsLoad[i]))
		$Main.get_child(i).add_child(item)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		self.visible = !self.visible
