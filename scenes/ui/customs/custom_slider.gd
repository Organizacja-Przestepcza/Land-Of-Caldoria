extends Control
@export var slider_value: int 
# Funkcja _ready() wykonuje się po załadowaniu sceny
func _ready():
	# Inicjalizacja wartości slidera, jeśli potrzebne
	var slider = $MarginContainer/HSlider
	slider.value = 100
	slider_value = slider.value

# Getter: Odczytanie wartości suwaka
func get_slider_value() -> int:
	var slider = $MarginContainer/Slider
	return slider.value

# Setter: Ustawianie wartości suwaka
func set_slider_value(value: int) -> void:
	var slider = $MarginContainer/Slider
	slider.value = value
