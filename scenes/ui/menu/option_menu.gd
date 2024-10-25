extends Control

var isFullscreen: bool = false 

func initial_controls_setup():
	%BackButton.set_label("Go back")
	%HeaderLabel/MarginContainer/Label.text = "Options"
	
	%MusicSlider.value = 100
	%MusicLabel/MarginContainer/Label .text = ("Music: " + str(%MusicSlider.value) + "%")
	
	%SoundSlider.value = 100
	%SoundLabel/MarginContainer/Label.text = ("Sound: " + str(%SoundSlider.value) + "%")
	
	%ResolutionsOptions/MarginContainer/OptionButton.add_item("1920×1080 (Full HD)", 1)
	%ResolutionsOptions/MarginContainer/OptionButton.add_item("1366×768",2)
	
	%FullscreenButton.set_label("Fullscreen: off")
	
	%KeybindsButton.set_label("Keybinds")

func _ready() -> void:
	initial_controls_setup()
	

func _on_back_button_button_pressed() -> void:
		emit_signal("backbutton_pressed")
signal backbutton_pressed


func _on_fullscreen_button_button_pressed() -> void:
	isFullscreen = !isFullscreen
	if isFullscreen:
		%FullscreenButton.set_label("Fullscreen: on")
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		%ResolutionsOptions/MarginContainer/OptionButton.disabled = true
	else:
		%FullscreenButton.set_label("Fullscreen: off")
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		%ResolutionsOptions/MarginContainer/OptionButton.disabled = false

func _on_music_slider_value_changed(value: float) -> void:
	%MusicLabel/MarginContainer/Label.text = "Music: " + str(%MusicSlider.value) + "%"



func _on_sound_slider_value_changed(value: float) -> void:
	%SoundLabel/MarginContainer/Label.text = "Sound: " + str(%SoundSlider.value) + "%"
