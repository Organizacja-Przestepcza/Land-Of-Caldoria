extends Control
class_name Trading
@onready var inventory: Inventory = $"../Inventory"

var player: Player

@onready var buy_list: ItemList = $TextureRect/VBoxContainer/HBoxContainer/BuyContainer/BuyList
@onready var sell_list: ItemList = $TextureRect/VBoxContainer/HBoxContainer/SellContainer/SellList
@onready var money_counter: Money = $TextureRect/VBoxContainer/MoneyCounter

var curr_npc: NPC

class ItemInList:
	var data: Item
	var amount: int
	var value: int

func open() -> void:
	if player.nearest_interactable is NPC:
		get_tree().paused = true
		self.visible = true
		update_lists(player.nearest_interactable)
		
func close() -> void:
	get_tree().paused = false
	self.visible = false
func update_lists(npc:NPC) -> void:
	curr_npc = npc
	update_buy_list()
	update_sell_list()

func update_buy_list():
	buy_list.clear()
	for item: Item in curr_npc.inventory:
		if curr_npc.inventory[item] > 0:
			buy_list.add_item(item.name + " Amount: "+ str(curr_npc.inventory[item]) + " Price: " + str(item.value))
			var d = ItemInList.new()
			d.data = item
			d.amount = curr_npc.inventory[item]
			d.value = item.value
			buy_list.set_item_metadata(buy_list.get_item_count() - 1, d)
	
func update_sell_list():
	sell_list.clear()
	var inv = inventory.to_list()
	for item in inv.keys():
		if curr_npc.accepted_items.has(item): 
			var price = item.value * curr_npc.accepted_items[item]
			sell_list.add_item(item.name + " Amount: "+ str(inv[item]) +" Price: " + str(price))
			var d = ItemInList.new()
			d.data = item
			d.amount = inv[item]
			d.value = price
			sell_list.set_item_metadata(sell_list.get_item_count() - 1, d)

func _on_sell_button_pressed() -> void:
	var selected_items = sell_list.get_selected_items()
	if selected_items:
		var selected_item: ItemInList = sell_list.get_item_metadata(selected_items[0])
		inventory.remove_item(selected_item.data,1)
		money_counter.add(selected_item.value)
		update_sell_list()

func _on_sell_all_button_pressed() -> void:
	var selected_items = sell_list.get_selected_items()
	if selected_items:
		var selected_item: ItemInList = sell_list.get_item_metadata(selected_items[0])
		inventory.remove_item(selected_item.data,selected_item.amount)
		money_counter.add(selected_item.value * selected_item.amount)
		update_sell_list()

func _on_buy_button_pressed() -> void:
	var selected_items = buy_list.get_selected_items()
	if selected_items:
		var selected_item: ItemInList = buy_list.get_item_metadata(selected_items[0])
		if money_counter.money < selected_item.value:
			return
		money_counter.remove(selected_item.value)
		curr_npc.inventory[selected_item.data] -= 1
		inventory.add_item(selected_item.data,1)
		update_buy_list()


func _on_buy_all_button_pressed() -> void:
	var selected_items = buy_list.get_selected_items()
	if selected_items:
		var selected_item: ItemInList = buy_list.get_item_metadata(selected_items[0])
		if money_counter.money < selected_item.value * selected_item.amount:
			return
		money_counter.remove(selected_item.value)
		curr_npc.inventory[selected_item.data] -= selected_item.amount
		inventory.add_item(selected_item.data,selected_item.amount)
		update_buy_list()
