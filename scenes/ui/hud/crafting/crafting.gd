extends Control

@onready var hud: Hud = self.get_parent()
@onready var inventory_list = $MarginContainer/CraftingContainer/InventoryContainer/InventoryList
func open_crafting() -> void:
	self.visible = true
	var inventory: Dictionary = hud.inventory_to_list()
	for item in inventory.keys():
		inventory_list.add_item(item.name)


func _on_exit_button_pressed() -> void:
	self.visible = false
	print("click")
