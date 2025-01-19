extends ScrollContainer
var custom_actions = InputMap.get_actions().filter(func(action: StringName): return action.begins_with("LC"))
@onready var vbox: VBoxContainer = $MarginContainer/VBoxContainer
@onready var options: VBoxContainer = $"../OptionsContainer"
var exit_button: Button
func _ready() -> void:
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
		label = Label.new() 
		label.label_settings = lbl_settings
		label.focus_mode = Control.FOCUS_ALL
		var input = InputMap.action_get_events(action_name).filter(func(action): return action is InputEventJoypadButton or action is InputEventJoypadMotion).front()
		if input is InputEventJoypadButton: 
			label.text = input.as_text().get_slice("(",1).get_slice(",",0).trim_suffix(")")
		elif input is InputEventJoypadMotion:
			label.text = input.as_text().get_slice("(",1).get_slice(",",1).get_slice(")",0)
		else:
			label.text = "notbound"
		#label.text = input.as_text().get_slice("(",1).get_slice(",",0) if input else "not bound"
		hbox.add_child(label)
	# Exit button
	exit_button = Button.new()
	exit_button.text = "Back"
	exit_button.pressed.connect(_on_exit_button_pressed)
	vbox.add_child(exit_button)
	
func _on_exit_button_pressed():
	hide()
	options.show()

func _on_visibility_changed() -> void:
	if visible: exit_button.grab_focus()
