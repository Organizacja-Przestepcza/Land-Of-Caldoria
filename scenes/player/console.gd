extends Control
class_name Console

@onready var line_edit: LineEdit = $LineEdit
@onready var player: Player = %Player
@onready var inventory: Inventory = %Inventory
var last_state
var history: PackedStringArray
var history_index: int = -1

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
	args.resize(3)
	match args[0]:
		"teleport", "tp": teleport(args.slice(1))
		"give": give(args[1], args[2])
		"clean": clean()
		_: print("Unknown command")
	history.append(line_edit.text)
	line_edit.clear()

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed:
			match event.keycode:
				KEY_UP:
					history_index += 1
					if history_index < history.size():
						line_edit.text = history[history_index]
					else:
						history_index = -1
				KEY_DOWN:
					history_index -= 1
					if history_index > -1:
						line_edit.text = history[history_index]
					else:
						line_edit.clear()

func teleport(args: PackedStringArray):
	if args.size() > 0:
		if not args[0].is_valid_float():
			print("\"",args[0], "\" is not a valid number")
			return
		if not args[1].is_valid_float():
			print("\"",args[1], "\" is not a valid number")
			return
		get_tree().paused = false
		player.global_position = Vector2i(args[0].to_float(), args[1].to_float())
		get_tree().paused = true
		
func give(item_name: String, amount_str: String):
	if item_name.is_empty():
		print("Specify an item name")
		return
	if not amount_str.is_valid_int():
		amount_str="1"
	var amount = amount_str.to_int()
	print(item_name)
	var item = ItemLoader.name(item_name)
	if item is Item:
		inventory.add_item(item,abs(amount))
	else:
		print("No such item")

func clean():
	inventory.clean()
