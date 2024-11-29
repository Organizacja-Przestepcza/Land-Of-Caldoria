extends Node
class_name Game

var state: State = State.PLAYING
@onready var trading: Trading = $"../Interface/Trading"

@onready var building: BuildMenu = %Building
@onready var crafting: Crafting = %Crafting

@onready var console: Console = $"../Interface/Console"

@onready var hotbar: Hotbar = %Hotbar
@onready var inventory: Inventory = %Inventory
@onready var player: Player = %Player
@onready var stats: Control = %Stats
@onready var tabs: TabContainer = %Tabs

enum State {PLAYING, INVENTORY, CONSOLE}

func _input(event: InputEvent) -> void:
	if event is InputEventKey and not event.echo:
		match state:
			State.PLAYING:
				if event.is_action_pressed("use", true):
					player.use_item()
				elif event.is_action_pressed("drop_item"):
					inventory.drop_item_in_slot(hotbar.selected_slot,1)
				elif event.is_action_pressed("interact"):
					player.interact()
				elif event.is_action_pressed("build_menu"):
					tabs.open(2)
				elif event.is_action_pressed("gui_inventory"):
					tabs.open(0)
				elif event.is_action_pressed("crafting_menu"):
					tabs.open(1)
					state = State.INVENTORY
				elif event.is_action_pressed("ui_stats"):
					tabs.open(3)
					state = State.INVENTORY
				elif event.is_action_pressed("ui_text_backspace"):
					print(%Player.position)
				elif event.pressed:
					match event.physical_keycode:
						KEY_1: hotbar.select_slot(0)
						KEY_2: hotbar.select_slot(1)
						KEY_3: hotbar.select_slot(2)
						KEY_4: hotbar.select_slot(3)
						KEY_5: hotbar.select_slot(4)
						KEY_6: hotbar.select_slot(5)
						KEY_QUOTELEFT: console.open()
			State.INVENTORY:
				if event.is_action_pressed("drop_item"):
					var slot = get_slot_under_mouse()
					if slot:
						inventory.drop_item_in_slot(slot,1)
				elif event.is_action_pressed("use"):
					var slot = get_slot_under_mouse()
					if slot and slot.get_child_count() > 0:
						var item = slot.get_child(0)
						if item is InventoryItem:
							player.consume(item,1)
					
				elif event.is_action_pressed("crafting_menu"):
					close_menus()
				elif event.is_action_pressed("build_menu"):
					close_menus()
				elif event.is_action_pressed("gui_inventory"):
					close_menus()
				elif event.is_action_pressed("ui_cancel"):
					close_menus()
					%PauseMenu.toggle()
			State.CONSOLE:
				if event.pressed and event.physical_keycode == KEY_QUOTELEFT:
					console.close()
				elif event.is_action_pressed("ui_cancel"):
					console.close()
					%PauseMenu.toggle()


func get_slot_under_mouse() -> InventorySlot:
	var mouse_pos = get_viewport().get_mouse_position()
	for container in inventory.containers:
		for slot in container.get_children():
			if slot is InventorySlot and slot.get_global_rect().has_point(mouse_pos):
				return slot
	return null  # No slot found under mouse

func close_menus():
	tabs.close()
