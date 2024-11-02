class_name Hud
extends CanvasLayer

@onready var inventory = $Inventory
@onready var hotbar = $Hotbar


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("gui_inventory"):
		inventory.visible = !inventory.visible
		if inventory.visible && hotbar.visible:
			hotbar.visible = false;
		else:
			hotbar.visible = true;
