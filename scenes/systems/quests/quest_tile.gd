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

func set_completed(_quest: QuestEntry):
	check.show()

func set_uncompleted(_quest: QuestEntry):
	check.hide()
