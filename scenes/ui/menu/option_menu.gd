extends Control

var is_fullscreen: bool = false 

func initial_controls_setup():
	
	%MusicSlider.value = _to_linear(Settings.music_volume)
	%MusicLabel .text = ("Music: " + str(%MusicSlider.value) + "%")
	
	%SoundSlider.value = _to_linear(Settings.sound_volume)
	%SoundLabel.text = ("Sound: " + str(%SoundSlider.value) + "%")
	
	

func _ready() -> void:
	initial_controls_setup()
	

func _on_back_button_pressed() -> void:
	backbutton_pressed.emit()
signal backbutton_pressed


func _on_fullscreen_button_pressed() -> void:
	is_fullscreen = !is_fullscreen
	if is_fullscreen:
		%FullscreenButton.text = ("Fullscreen: on")
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		%ResolutionOptions.disabled = true
	else:
		%FullscreenButton.text = ("Fullscreen: off")
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		%ResolutionOptions.disabled = false

func _on_music_slider_value_changed(value: float) -> void:
	%MusicLabel.text = "Music: " + str(%MusicSlider.value) + "%"
	Settings.music_volume = _to_db(value)
	if get_tree().root.has_node("World"):
		var world = get_tree().root.get_node("World")
		world.update_volume()

func _on_sound_slider_value_changed(value: float) -> void:
	%SoundLabel.text = "Sound: " + str(%SoundSlider.value) + "%"
	Settings.sound_volume = _to_db(value)

func _on_keybinds_button_pressed() -> void:
	pass # Replace with function body.

func _to_db(value: float) -> float:
	return lerp(-80, 0, log(1 + value) / log(101))
func _to_linear(volume_db: float) -> float:
	return exp((volume_db - (-80)) / (0 - (-80)) * log(101)) - 1
