extends Control
var inventory
var player: Player
@onready var hud : Hud = get_parent()
var npc_inventory = [ItemDB.items["stone"]]
func _ready() -> void:
	inventory = hud.get_node("Inventory")
	var account = hud.get_node("MoneyCounter")
	await get_tree().create_timer(1).timeout
	update_sell()
	update_buy()

func update_sell() -> void:
	for slot: InventorySlot in inventory.main.get_children(): 
			var item: InventoryItem = slot.get_child(0) 
			if item != null and npc_inventory.has(item.data): 
				$TextureRect/VBoxContainer/HBoxContainer/SellContainer/SellList.add_item(item.data.name)
func update_buy() -> void:
	for item: Item in npc_inventory:
		$TextureRect/VBoxContainer/HBoxContainer/BuyContainer/BuyList.add_item(item.name)
