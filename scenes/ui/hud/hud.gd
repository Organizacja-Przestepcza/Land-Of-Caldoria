class_name Hud
extends CanvasLayer

@onready var inventory = $Inventory
@onready var hotbar = $Hotbar/MarginContainer/Hotbar
@onready var main = $Inventory/HBoxContainer/VBoxContainer/Main

var selected_slot: int

var itemsLoad = [
	"res://items/resource/wood/log.tres",
	"res://items/food/blueberry/blueberry.tres",
	"res://items/food/blueberry/blueberry.tres"
]

func find_free_space() -> int:
	for i in hotbar.get_child_count():
		if hotbar.get_child(i).get_child_count() == 0:
			return i
	for i in main.get_child_count():
		if main.get_child(i).get_child_count() == 0:
			return i + hotbar.get_child_count()
	return -1

func add_item(new_item) -> void:
	var index = find_free_space()
	var item = InventoryItem.new()
	item.init(load(new_item))
	if index >= 0 && index <= 5:
		hotbar.get_child(index).add_child(item)
	elif index > 5:
		main.get_child(index - hotbar.get_child_count()).add_child(item)
		
func remove_item(index):
	if index >= 0 && index <= 5:
		var item_at_index = hotbar.get_child(index).get_child(0)
		if item_at_index != null:
			item_at_index.queue_free()
	elif index > 5:
		var item_at_index = main.get_child(index - hotbar.get_child_count()).get_child(0)
		if item_at_index != null:
			item_at_index.queue_free()
	
func _ready() -> void:
	for i in itemsLoad:
		add_item(i)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("drop_item"):
		print("q pressed")
		remove_item(selected_slot)
	if Input.is_action_just_pressed("gui_inventory"):
		inventory.visible = !inventory.visible
		if inventory.visible:
			hotbar.reparent(inventory.get_node("HBoxContainer/VBoxContainer"))
			inventory.get_node("HBoxContainer/VBoxContainer").move_child(hotbar, 0)
		else:
			hotbar.reparent(get_node("Hotbar/MarginContainer"))


func _on_inventory_inv_slot_click(index: int) -> void:
	selected_slot = index + hotbar.get_child_count()
	print(selected_slot)
