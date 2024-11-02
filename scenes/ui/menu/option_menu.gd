extends Control

var isFullscreen: bool = false 

func initial_controls_setup():
	
	%MusicSlider.value = 100
	%MusicLabel .text = ("Music: " + str(%MusicSlider.value) + "%")
	
	%SoundSlider.value = 100
	%SoundLabel.text = ("Sound: " + str(%SoundSlider.value) + "%")
	
	

func _ready() -> void:
	initial_controls_setup()
	

func _on_back_button_pressed() -> void:
		emit_signal("backbutton_pressed")
signal backbutton_pressed


func _on_fullscreen_button_pressed() -> void:
	isFullscreen = !isFullscreen
	if isFullscreen:
		%FullscreenButton.text = ("Fullscreen: on")
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		%ResolutionOptions.disabled = true
	else:
		%FullscreenButton.text = ("Fullscreen: off")
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		%ResolutionOptions.disabled = false

func _on_music_slider_value_changed(value: float) -> void:
	%MusicLabel.text = "Music: " + str(%MusicSlider.value) + "%"



func _on_sound_slider_value_changed(value: float) -> void:
	%SoundLabel.text = "Sound: " + str(%SoundSlider.value) + "%"


func _on_keybinds_button_pressed() -> void:
	pass # Replace with function body.
