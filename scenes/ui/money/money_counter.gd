extends Control
class_name Money
var money = 5

func _ready() -> void:
	update_label()
	
func update_label() -> void:
	$HBoxContainer/Label.text = str(money)
	
func add(value:int) -> void:
	if value > 0:
		money += value
	update_label()
	
func remove(value:int) -> void:
	if money >= value:
		money -= value
	update_label()
