extends Control
class_name Console

@onready var line_edit: LineEdit = $LineEdit
@onready var player: Player = %Player
@onready var inventory: Inventory = %Inventory
@onready var game: Game = %Game
var last_state
var history: PackedStringArray
var history_index: int = 0

func open():
	last_state = game.state
	game.state = Game.State.CONSOLE
	get_tree().paused = true
	self.visible = true
	await get_tree().create_timer(0.01).timeout
	line_edit.grab_focus()

func close() -> void:
	game.state = last_state
	get_tree().paused = false
	self.visible = false
	line_edit.clear()

func _on_line_edit_text_submitted(_new_text: String) -> void:
	var args = line_edit.text.split(" ",false)
	args.resize(4)
	match args[0]:
		"help", "?": help()
		"teleport", "tp": teleport(args.slice(1))
		"give": give(args[1], args[2])
		"clean": clean()
		"clear": 
			history.clear()
			history_index=0
			line_edit.clear()
			return
		"camera": camera(args[1])
		"spawn": spawn(args[1])
		"quest": quest(args[1], args[2])
		"render": 
			var err = render(args[1],args[2])
			if err:
				print(error_string(err))
		_: print("Unknown command")
	history.append(line_edit.text)
	line_edit.clear()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and visible == true:
		if event.is_action_pressed("ui_cancel"):
			close()
			$"../../PauseMenu".toggle()
		elif event.pressed:
			match event.keycode:
				KEY_UP:
					if history_index < history.size():
						history_index += 1
						line_edit.text = history[history.size()-history_index]
				KEY_DOWN:
					if history_index > 1:
						history_index -= 1
						line_edit.text = history[history.size()-history_index]
					elif history_index > 0:
						history_index -= 1
						line_edit.clear()

func quest(command: String, id_str: String):
	print("Command doesn't work, sorry")
	return
	if command.is_empty():
		print("Available args: complete")
		return
	if not id_str.is_valid_int():
		print("Wrong id format")
		return
	var id = id_str.to_int()
	print("Trying to %s quest with id %d"%[command,id])
	if not QuestHandler.quest_manager.has_quest(id):
		print("Quest with this id doesn't exist")
		return
	var q_entry = QuestHandler.quest_manager.get_quest(id) as QuestEntry
	if q_entry.is_active():
		q_entry.set_completed()
	else:
		print("Quest not active")
	

func teleport(args: PackedStringArray):
	if args.size() > 0:
		if not args[0].is_valid_float():
			print("\"",args[0], "\" is not a valid number")
			return
		if not args[1].is_valid_float():
			print("\"",args[1], "\" is not a valid number")
			return
		get_tree().paused = false
		player.global_position = Vector2(args[0].to_float(), args[1].to_float())
		get_tree().paused = true
		
func give(item_name: String, amount_str: String):
	if item_name.is_empty():
		print("Specify an item name")
		return
	if not amount_str.is_valid_int():
		amount_str="1"
	var amount = amount_str.to_int()
	print(item_name)
	if item_name == "money" or item_name == "coin":
		player.money.add(amount)
		SignalBus.coins_changed.emit(amount)
		return
	var item = ItemLoader.name(item_name)
	if item is Item:
		inventory.add_item(item,abs(amount))
	else:
		print("No such item")

func clean():
	inventory.clean()

func help():
	print("Available commands:\n
	teleport {x: float} {y: float} - teleports you\n
	give {item_name: string} {amount: int} - gives you items\n
	clean - deletes all your items\n
	clear - clears command line history\n
	render distance {distance: int} - changes render distance\n
	render unload {true/false} - sets whether to unload chunks out of render distance or not")

func render(subcommand, value: String) -> Error:
	match subcommand:
		"distance":
			if not value.is_valid_int():
				return ERR_INVALID_PARAMETER
			var distance = value.to_int()
			var chunk_loader = player.get_parent().chunk_loader
			if chunk_loader is ChunkLoader:
				chunk_loader.loading_radius = Vector2i(distance,distance)
				print("Render distance set to ", value)
			else:
				printerr("Chunk loader is ", chunk_loader)
		"unload":
			var chunk_loader = player.get_parent().chunk_loader
			if chunk_loader is ChunkLoader:
				if value.to_lower() in ["enable", "true"]:
					chunk_loader.unload_chunks = true
					print("Chunk unloading enabled")
				elif value.to_lower() in ["disable", "false"]:
					chunk_loader.unload_chunks = false
					print("Chunk unloading disabled")
				else:
					return ERR_INVALID_PARAMETER
			else:
				return FAILED
		_:
			return ERR_INVALID_PARAMETER
	return OK

func camera(value):
	if value is String:
		if not value.is_valid_float():
			return
		var zoom = value.to_float()
		player.update_zoom(Vector2(zoom,zoom))

func spawn(mob):
	if mob is String:
		print("Not implemented")
