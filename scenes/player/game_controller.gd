extends Node
class_name Game

var state: State = State.PLAYING
@onready var trading: Trading = $"../Interface/Trading"
@onready var hint_legend: HintLegend = %HintLegend

@onready var building: BuildMenu = %Building
@onready var crafting: Crafting = %Crafting
@onready var ammo_selector: AmmoSelector = $"../Interface/AmmoSelector"
@onready var furnace: Furnace = $"../Interface/Furnace"

@onready var console: Console = $"../Interface/Console"
@onready var pause_menu: PauseMenu = %PauseMenu
@onready var hotbar: Hotbar = %Hotbar
@onready var inventory: Inventory = %Inventory
@onready var player: Player = %Player
@onready var stats: Stats = %Stats
@onready var tabs: TabContainer = %Tabs
var joypad_selected_slot: InventorySlot:
	get:
		return joypad_selected_slot
	set(new_slot):
		if joypad_selected_slot:
			joypad_selected_slot.theme_type_variation = &"InventorySlot"
		if new_slot: 
			new_slot.theme_type_variation = &"InventorySlotSelected"
		joypad_selected_slot = new_slot
enum State {PLAYING, INVENTORY, CONSOLE}

# Adjust sensitivity to control how fast the mouse moves
var sensitivity: float = 3.5

func _physics_process(delta: float) -> void:
	if Input.get_connected_joypads().size() < 1: return
# Get raw input from the right analog stick
	var direction = Vector2()
	direction.x = int(Input.is_action_pressed("right_stick_right")) - int(Input.is_action_pressed("right_stick_left"))
	direction.y = int(Input.is_action_pressed("right_stick_down")) - int(Input.is_action_pressed("right_stick_up"))
	direction.normalized()
	
# Create a movement vector and scale it
	var mouse_movement = direction * sensitivity 
# Get the current mouse position
	var mouse_position = get_viewport().get_mouse_position()
# Update the mouse position
	mouse_position += mouse_movement
	# Set the new mouse position
	
	# Check if the controller button assigned to "mouse_left_toggle" is pressed
	
	Input.warp_mouse(mouse_position)
func _ready() -> void:
	SignalBus.player_attacked.connect(_on_player_attacked)

func _on_player_attacked(mob,damage):
	var controller= Input.get_connected_joypads().front()
	if controller is int:
		Input.start_joy_vibration(controller,0.1,0.5,0.2)
func _input(event: InputEvent) -> void:
		match state:
			State.PLAYING:
				if get_tree().paused == false:
					if event.is_action_pressed("LC_use",true):
						player.use_item()
					elif event.is_action_pressed("LC_drop_item"):
						inventory.drop_item_in_slot(hotbar.selected_slot,1)
					elif event.is_action_pressed("LC_interact"):
						player.interact()
					elif event.is_action_pressed("LC_throw"):
						var item = hotbar.get_held_item()
						if item and item.is_throwable:
							player.throw(item)
					elif event.is_action_pressed("LC_build_menu"):
						tabs.open(2)
					elif event.is_action_pressed("LC_inventory"):
						tabs.open(0)
					elif event.is_action_pressed("LC_crafting_menu"):
						tabs.open(1)
					elif event.is_action_pressed("LC_stats"):
						tabs.open(3)
					elif event.is_action_pressed("ui_text_backspace"):
						print($"..".position)
					elif event.is_action_pressed("LC_switch_ammo"):
						ammo_selector.open()
					elif event.is_action_pressed("joypad_next_tab"):
						hotbar.select_next_slot()
					elif event.is_action_pressed("joypad_previous_tab"):
						hotbar.select_previous_slot()
					elif event is InputEventKey and not event.echo and event.pressed:
						match event.physical_keycode:
							KEY_1: hotbar.select_slot(0)
							KEY_2: hotbar.select_slot(1)
							KEY_3: hotbar.select_slot(2)
							KEY_4: hotbar.select_slot(3)
							KEY_5: hotbar.select_slot(4)
							KEY_6: hotbar.select_slot(5)
							KEY_QUOTELEFT: console.open()
			State.INVENTORY:
				if event.is_action_pressed("LC_drop_item"):
					var slot = get_slot_under_mouse()
					if slot:
						inventory.drop_item_in_slot(slot,1)
				elif event.is_action_pressed("joypad_drag_and_drop"):
					var slot = get_slot_under_mouse()
					if slot:
						if joypad_selected_slot: 
							var selected_slot_item = joypad_selected_slot.get_child(0)
							var new_slot_item = slot.get_child(0)
							if selected_slot_item:
								selected_slot_item.reparent(slot)
							if new_slot_item:
								new_slot_item.reparent(joypad_selected_slot)
							joypad_selected_slot = null
						else:
							joypad_selected_slot = slot
				elif event.is_action_pressed("LC_use"):
					var slot = get_slot_under_mouse()
					if slot and slot.get_child_count() > 0:
						var item = slot.get_child(0)
						if item is InventoryItem:
							player.consume(item,1)
					
				elif event.is_action_pressed("LC_crafting_menu"):
					close_menus()
				elif event.is_action_pressed("LC_build_menu"):
					close_menus()
				elif event.is_action_pressed("LC_inventory"):
					close_menus()
				elif event.is_action_pressed("LC_switch_ammo"):
					close_menus()
				elif event.is_action_pressed("ui_cancel"):
					close_menus()
					pause_menu.toggle()
				elif event.is_action_pressed("joypad_next_tab"):
					tabs.select_next_available()
				elif event.is_action_pressed("joypad_previous_tab"):
					tabs.select_previous_available()
			State.CONSOLE:
				if event is InputEventKey and event.pressed and event.physical_keycode == KEY_QUOTELEFT:
					console.close()
				elif event.is_action_pressed("ui_cancel"):
					console.close()
					pause_menu.toggle()


func get_slot_under_mouse() -> InventorySlot:
	var mouse_pos = get_viewport().get_mouse_position()
	for container in inventory.containers:
		for slot in container.get_children():
			if slot is InventorySlot and slot.get_global_rect().has_point(mouse_pos):
				return slot
	return null  # No slot found under mouse

func close_menus():
	tabs.close()
	ammo_selector.close()
	furnace.close()
