extends CanvasLayer

var invSize: int = 24
var slotSize: Vector2 = Vector2(64,64)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in invSize:
		var slot = InventorySlot.new(InventorySlot.Type.MAIN,slotSize)
		$Main.add_child(slot)
	var headSlot = InventorySlot.new(InventorySlot.Type.HEAD,slotSize)
	var torsoSlot = InventorySlot.new(InventorySlot.Type.TORSO,slotSize)
	var armsSlot = InventorySlot.new(InventorySlot.Type.ARMS,slotSize)
	var legsSlot = InventorySlot.new(InventorySlot.Type.LEGS,slotSize)
	var feetSlot = InventorySlot.new(InventorySlot.Type.FEET,slotSize)
	$Armor.add_child(headSlot)
	$Armor.add_child(torsoSlot)
	$Armor.add_child(armsSlot)
	$Armor.add_child(legsSlot)
	$Armor.add_child(feetSlot)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
