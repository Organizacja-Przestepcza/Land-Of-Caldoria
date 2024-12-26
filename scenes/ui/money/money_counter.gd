extends Control
class_name Money
@onready var player: Player = WorldData.player
var _count = 5

func _ready() -> void:
	update_label()
	
func update_label() -> void:
	$HBoxContainer/Label.text = str(_count)
	
func add(value:int) -> void:
	_count += maxi(value,0)
	update_label()
	
func remove(value:int) -> void:
	_count -= mini(value,_count)
	update_label()

func get_count():
	return _count
