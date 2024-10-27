# HungerDisplay.gd
extends TextureRect

# Maksymalny poziom głodu
const MAX_HUNGER = 15
# Tempo spadku głodu (im wyższe, tym szybciej głód się zmniejsza)
const HUNGER_DECAY_RATE = 1  # np. 1 punkt na sekundę

# Aktualny poziom głodu
var hunger = MAX_HUNGER

# Referencje do węzłów
@onready var hunger_label = $Label  # Etykieta dla tekstu głodu

# Funkcja wywoływana co sekundę, aby zmniejszać głód
func _process(delta):
	# Zmniejszamy głód, dopóki nie osiągnie zera
	if hunger > 0:
		hunger -= HUNGER_DECAY_RATE * delta
		hunger = clamp(hunger, 0, MAX_HUNGER)
		# Aktualizacja tekstu głodu
		update_hunger_text()

# Funkcja odnawiająca głód po zebraniu jedzenia
func replenish(amount):
	hunger += amount
	hunger = clamp(hunger, 0, MAX_HUNGER)
	update_hunger_text()

# Funkcja aktualizująca tekst głodu
func update_hunger_text():
	hunger_label.text = str(int(hunger)) + "/" + str(MAX_HUNGER) + " głodu"
