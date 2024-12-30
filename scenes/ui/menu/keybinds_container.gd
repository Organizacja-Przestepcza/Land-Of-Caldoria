extends ScrollContainer
@onready var vbox: VBoxContainer = $MarginContainer/VBoxContainer
@onready var options: VBoxContainer = $"../OptionsContainer"
@onready var config := ConfigFile.new()

var custom_actions = InputMap.get_actions().filter(func(action: StringName): return action.begins_with("LC"))
var waiting_for_input: bool = false
var selected_action: StringName

signal new_input_selected(input: InputEvent)

func _input(event: InputEvent) -> void:
	if not waiting_for_input:
		return
	if event is InputEventKey or event is InputEventMouseButton:
		waiting_for_input = false
		new_input_selected.emit(event)

func _ready() -> void:
	config.load(OptionMenu.SETTINGS_FILE_PATH)
	if config.has_section("KEYBINDS"):
		for action_name in config.get_section_keys("KEYBINDS"):
			if InputMap.has_action(action_name):
				var input: InputEvent = _get_event_for_action(action_name)
				var key = OS.find_keycode_from_string(config.get_value("KEYBINDS",action_name))
				if key != KEY_NONE:
					var user_input = InputEventKey.new()
					user_input.keycode = key
					InputMap.action_erase_event(action_name,input)
					InputMap.action_add_event(action_name,user_input)
				else:
					key = find_mouse_button_from_string(config.get_value("KEYBINDS",action_name))
					if key != MOUSE_BUTTON_NONE:
						var user_input = InputEventMouseButton.new()
						user_input.button_index = key
						InputMap.action_erase_event(action_name,input)
						InputMap.action_add_event(action_name,user_input)
	populate_keybinds()

func populate_keybinds():
	var lbl_settings := LabelSettings.new()
	lbl_settings.font_size = 60
	for action_name: StringName in custom_actions:
		# action hbox
		var hbox := HBoxContainer.new()
		hbox.alignment = BoxContainer.ALIGNMENT_CENTER
		vbox.add_child(hbox)
		# action label
		var label := Label.new()
		label.label_settings = lbl_settings
		label.text = action_name.trim_prefix("LC_").capitalize().replace("_"," ")
		hbox.add_child(label)
		# spacer
		var spacer = Control.new()
		spacer.size_flags_horizontal = Control.SIZE_EXPAND
		hbox.add_child(spacer)
		# action button
		var button := Button.new()
		var input: InputEvent = InputMap.action_get_events(action_name).filter(func(action): return action is InputEventKey or action is InputEventMouseButton).front()
		button.text = input.as_text().get_slice(" (",0)
		button.add_to_group(&"keybind_buttons")
		button.custom_minimum_size = Vector2i(50,60)
		button.set_meta(&"action_name",action_name)
		button.pressed.connect(_on_button_pressed.bind(action_name,button,input))
		hbox.add_child(button)
	# Hbox container
	var hbox := HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 200)
	hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_child(hbox)
	# Exit button
	var exit_button := Button.new()
	exit_button.text = "Back"
	exit_button.pressed.connect(_on_exit_button_pressed)
	hbox.add_child(exit_button)
	# Apply button
	var apply_button := Button.new()
	apply_button.text = "Apply"
	apply_button.pressed.connect(_on_apply_button_pressed) # connect saving
	hbox.add_child(apply_button)
	# Reset button
	var reset_button := Button.new()
	reset_button.text = "Reset"
	reset_button.pressed.connect(_on_reset_button_pressed)
	hbox.add_child(reset_button)

func set_button_texts():
	for button in get_tree().get_nodes_in_group(&"keybind_buttons"):
		var action_name = button.get_meta(&"action_name")
		var input: InputEvent = InputMap.action_get_events(action_name).filter(func(action): return action is InputEventKey or action is InputEventMouseButton).front()
		button.text = input.as_text().get_slice(" (",0)

func _on_button_pressed(action: StringName, button: Button, input: InputEvent) -> void:
	var temp = button.text
	button.text = "..."
	waiting_for_input = true
	var new_input: InputEvent = await new_input_selected
	if new_input is InputEventKey and new_input.get_physical_keycode_with_modifiers() == KEY_ESCAPE:
		button.text = temp
		return
	InputMap.action_erase_event(action,input)
	InputMap.action_add_event(action,new_input)
	button.text = new_input.as_text().get_slice(" (",0)

func _on_exit_button_pressed() -> void:
	waiting_for_input = false
	self.hide()
	options.show()

func _on_apply_button_pressed() -> void:
	for button in get_tree().get_nodes_in_group(&"keybind_buttons"):
		var action_name = button.get_meta(&"action_name")
		var key = OS.find_keycode_from_string(button.text)
		InputEventMouseButton
		config.set_value("KEYBINDS",action_name,button.text)
	config.save(OptionMenu.SETTINGS_FILE_PATH)

func _on_reset_button_pressed() -> void:
	InputMap.load_from_project_settings()
	set_button_texts()

func _get_event_for_action(action_name: StringName):
	var input: InputEvent = InputMap.action_get_events(action_name).filter(func(action): return action is InputEventKey or action is InputEventMouseButton).front()
	return input

func find_mouse_button_from_string(button_name: String) -> int:
	match button_name.strip_edges().to_lower():
		"left mouse button": return MOUSE_BUTTON_LEFT
		"right mouse button": return MOUSE_BUTTON_RIGHT
		"middle mouse button": return MOUSE_BUTTON_MIDDLE
		"mouse wheel up": return MOUSE_BUTTON_WHEEL_UP
		"mouse wheel down": return MOUSE_BUTTON_WHEEL_DOWN
		"mouse wheel left": return MOUSE_BUTTON_WHEEL_LEFT
		"mouse wheel right": return MOUSE_BUTTON_WHEEL_RIGHT
		"thumb button 1": return MOUSE_BUTTON_XBUTTON1  # Thumb button 1
		"thumb button 2": return MOUSE_BUTTON_XBUTTON2  # Thumb button 2
		_: return MOUSE_BUTTON_NONE  # Invalid or unknown button
