extends Control
class_name Console

@onready var line_edit: LineEdit = $LineEdit
@onready var player: Player = %Player
@onready var inventory: Inventory = $"../Inventory"
var last_state

func open():
	last_state = %Game.state
	%Game.state = Game.State.CONSOLE
	get_tree().paused = true
	self.visible = true
	await get_tree().create_timer(0.01).timeout
	line_edit.grab_focus()

func close() -> void:
	%Game.state = last_state
	get_tree().paused = false
	self.visible = false

func _on_line_edit_text_submitted(new_text: String) -> void:
	var args = line_edit.text.split(" ",false)
	args.resize(5)
	match args[0]:
		"teleport": teleport(args.slice(1))
		"give": give(args[1], args[2])
		_: print("Unknown command")
	line_edit.clear()

func teleport(args: PackedStringArray):
	print(args)
	if args.size() > 0:
		if not args[0].is_valid_float():
			return
		if not args[1].is_valid_float():
			return
		get_tree().paused = false
		player.global_position = Vector2i(args[0].to_float(), args[1].to_float())
		get_tree().paused = true
		
func give(item_name: String, amount_str: String):
	if item_name.is_empty():
		print("You need to specify an item name")
		return
	if not amount_str.is_valid_int():
		print("You need to specify amount")
		return
	var amount = amount_str.to_int()
	print(item_name)
	var item = ItemLoader.name(item_name)
	if item is Item:
		inventory.add_item(item,abs(amount))
	else:
		print("No such item")
