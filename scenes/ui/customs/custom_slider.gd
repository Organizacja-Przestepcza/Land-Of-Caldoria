extends Control
signal custom_drag_ended
func _ready():
	var slider = $MarginContainer/HSlider
	slider.value = 100 
	

# Getter: Odczytanie wartości suwaka
func get_slider_value() -> int:
	var slider = $MarginContainer/HSlider
	return slider.value

# Setter: Ustawianie wartości suwaka
func set_slider_value(value: int) -> void:
	var slider = $MarginContainer/HSlider
	slider.value = value

	


func _on_h_slider_drag_ended(value_changed: bool) -> void:
	emit_signal("custom_drag_ended")
