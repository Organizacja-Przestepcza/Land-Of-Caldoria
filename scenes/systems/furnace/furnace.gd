extends Interface

@onready var hud: Hud = self.get_parent()
@onready var inventory_list = $MarginContainer/FurnaceContainer/InventoryContainer/InventoryList

func _on_exit_button_pressed() -> void:
	close()
