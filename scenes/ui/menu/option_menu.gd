extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var BackButton = $MarginContainer/VBoxContainer/BackButton
	BackButton.set_button_label("Go back")
	
	var HeaderLabel = $MarginContainer/VBoxContainer/HeaderLabel
	HeaderLabel.set_button_label("Options")
	
	var MusicSlider = $MarginContainer/VBoxContainer/MusicSlider
	MusicSlider.get_node("MarginContainer/HSlider").value = 50
	var MusicLabel = $MarginContainer/VBoxContainer/MusicLabel
	MusicLabel.get_node("MarginContainer/Label").text = ("Music: " + str(MusicSlider.get_node("MarginContainer/HSlider").value) + "%")
	
	var SoundSlider = $MarginContainer/VBoxContainer/SoundSlider
	var SoundLabel = $MarginContainer/VBoxContainer/SoundLabel
	SoundSlider.get_node("MarginContainer/HSlider").value = 75
	SoundLabel.get_node("MarginContainer/Label").text = ("Sound: " + str(SoundSlider.get_node("MarginContainer/HSlider").value) + "%")
	
	 #.text = ("Sound: " + str(SoundSlider.get_node("MarginContainer/HSlider").value) + "%")
	

func _on_back_button_button_pressed() -> void:
		emit_signal("backbutton_pressed")
signal backbutton_pressed
