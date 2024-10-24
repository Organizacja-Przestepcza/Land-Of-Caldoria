extends Control

var isFullscreen: bool = false 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var BackButton = $MarginContainer/VBoxContainer/BackButton
	BackButton.set_button_label("Go back")
	
	var HeaderLabel = $MarginContainer/VBoxContainer/HeaderLabel
	HeaderLabel.get_node("MarginContainer/Label").text = "Options"
	
	var MusicSlider = $MarginContainer/VBoxContainer/MusicSlider

	
	var MusicLabel = $MarginContainer/VBoxContainer/MusicLabel
	MusicLabel.get_node("MarginContainer/Label").text = ("Music: " + str(MusicSlider.get_node("MarginContainer/HSlider").value) + "%")
	
	var SoundSlider = $MarginContainer/VBoxContainer/SoundSlider
	var SoundLabel = $MarginContainer/VBoxContainer/SoundLabel
	SoundSlider.get_node("MarginContainer/HSlider").value = 75
	SoundLabel.get_node("MarginContainer/Label").text = ("Sound: " + str(SoundSlider.get_node("MarginContainer/HSlider").value) + "%")
	
	var ResolutionsOptions = $MarginContainer/VBoxContainer/ResolutionsOptions
	ResolutionsOptions.get_node("MarginContainer/OptionButton").add_item("1920×1080 (Full HD)", 1)
	ResolutionsOptions.get_node("MarginContainer/OptionButton").add_item("1366×768",2)
	
	var FullscreenButton = $MarginContainer/VBoxContainer/FullscreenButton
	FullscreenButton.set_button_label("Fullscreen: off")
	
	var KeyBindsButton = $MarginContainer/VBoxContainer/KeybindsButton
	KeyBindsButton.set_button_label("Keybinds")

func _on_back_button_button_pressed() -> void:
		emit_signal("backbutton_pressed")
signal backbutton_pressed


func _on_fullscreen_button_button_pressed() -> void:
	isFullscreen = !isFullscreen
	var FullscreenButton = $MarginContainer/VBoxContainer/FullscreenButton
	if isFullscreen:
		FullscreenButton.set_button_label("Fullscreen: on")
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		$MarginContainer/VBoxContainer/ResolutionsOptions.get_node("MarginContainer/OptionButton").disabled = true
	else:
		FullscreenButton.set_button_label("Fullscreen: off")
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		$MarginContainer/VBoxContainer/ResolutionsOptions.get_node("MarginContainer/OptionButton").disabled = false

		
func custom_drag_ended() -> void:
	var MusicSlider = $MarginContainer/VBoxContainer/MusicSlider
	$MarginContainer/VBoxContainer/MusicLabel.get_node("MarginContainer/Label").text = ("Music: " + str(MusicSlider.get_node("HSlider").value) + "%")
