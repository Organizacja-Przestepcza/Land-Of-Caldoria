extends Control
class_name OptionMenu

var is_fullscreen: bool = false
var config = ConfigFile.new()
const SETTINGS_FILE_PATH = "user://settings.cfg"
@onready var options_container: VBoxContainer = $OptionsContainer
@onready var keybinds_container: ScrollContainer = $KeybindsContainer

func settings_controls_setup():
	if config.has_section_key("MAIN_MENU_SECTION", "MUSIC_SLIDER_VALUE"):
		%MusicSlider.value = _to_linear(config.get_value("MAIN_MENU_SECTION", "MUSIC_SLIDER_VALUE"))
		%SoundLabel.text = ("Sound: " + str(%SoundSlider.value) + "%")
	else:
		%MusicSlider.value = _to_linear(Settings.music_volume)
		%MusicLabel .text = ("Music: " + str(%MusicSlider.value) + "%")
	
	if config.has_section_key("MAIN_MENU_SECTION", "SOUND_SLIDER_VALUE"):
		%SoundSlider.value = _to_linear(config.get_value("MAIN_MENU_SECTION", "SOUND_SLIDER_VALUE"))
		%SoundLabel.text = ("Sound: " + str(%SoundSlider.value) + "%")
	else:
		%SoundSlider.value = _to_linear(Settings.sound_volume)
		%SoundLabel.text = ("Sound: " + str(%SoundSlider.value) + "%")
	

func _ready() -> void:
	var err = config.load(SETTINGS_FILE_PATH) # SETTINGS_FILE_PATH = file path string to your settings file
	if err != OK: 
		print("opening config file failed" + str(err))
	settings_controls_setup()
	

func _on_back_button_pressed() -> void:
	backbutton_pressed.emit()
signal backbutton_pressed


func _on_fullscreen_button_pressed() -> void:
	is_fullscreen = !is_fullscreen
	if is_fullscreen:
		%FullscreenButton.text = ("Fullscreen: on")
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		%FullscreenButton.text = ("Fullscreen: off")
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_music_slider_value_changed(value: float) -> void:
	%MusicLabel.text = "Music: " + str(%MusicSlider.value) + "%"
	Settings.music_volume = _to_db(value)
	config.set_value("MAIN_MENU_SECTION", "MUSIC_SLIDER_VALUE", Settings.music_volume)
	config.save(SETTINGS_FILE_PATH)
	if get_tree().root.has_node("World"):
		var world = get_tree().root.get_node("World")
		world.update_volume()

func _on_sound_slider_value_changed(value: float) -> void:
	%SoundLabel.text = "Sound: " + str(%SoundSlider.value) + "%"
	Settings.sound_volume = _to_db(value)
	config.set_value("MAIN_MENU_SECTION", "SOUND_SLIDER_VALUE", Settings.sound_volume)
	config.save(SETTINGS_FILE_PATH)

func _on_keybinds_button_pressed() -> void:
	options_container.hide()
	keybinds_container.show()

func _to_db(value: float) -> float:
	return lerp(-80, 0, log(1 + value) / log(101))
func _to_linear(volume_db: float) -> float:
	return exp((volume_db - (-80)) / (0 - (-80)) * log(101)) - 1
