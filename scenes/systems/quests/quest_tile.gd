extends MarginContainer
class_name QuestTile

@onready var title: Label = $VBoxContainer/Title
@onready var objective: Label = $VBoxContainer/HBoxContainer/Objective
@onready var check: TextureRect = $VBoxContainer/HBoxContainer/Checkbox/Check

var _q_entry: QuestEntry

func init(quest: QuestEntry) -> void:
	_q_entry = quest

func _ready() -> void:
	print(self)
	print(title)
	await get_tree().create_timer(1).timeout
	print(get_children(true))
	#title.text = _q_entry.get_title()
	#objective.text = _q_entry.get_description()

func set_completed():
	check.show()

func set_uncompleted():
	check.hide()
