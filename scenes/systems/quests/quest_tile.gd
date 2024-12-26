extends MarginContainer
class_name QuestTile
@onready var title: Label = $VBoxContainer/Title
@onready var objective: Label = $VBoxContainer/HBoxContainer/Objective
@onready var check: TextureRect = $VBoxContainer/HBoxContainer/Checkbox/Check

var _q_entry: QuestEntry

func init(quest: QuestEntry) -> void:
	_q_entry = quest
	title.text = _q_entry.get_title()
	objective.text = _q_entry.get_description()
	set_visibility()

func set_visibility() -> void:
	check.visible = _q_entry.is_completed()

func set_completed(_quest: QuestEntry):
	if _q_entry.is_completed():
		check.show()
	else:
		check.hide()
