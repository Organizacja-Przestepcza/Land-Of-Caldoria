extends MarginContainer
class_name QuestTile
@onready var title: Label = $VBoxContainer/Title
@onready var objective: Label = $VBoxContainer/HBoxContainer/Objective
@onready var check: TextureRect = $VBoxContainer/HBoxContainer/Checkbox/Check
@onready var progress: Label = $VBoxContainer/HBoxContainer/Progress

func init(quest: QuestEntry) -> void:
	title.text = quest.get_title()
	objective.text = quest.get_description()
	update_progress(quest)
	update_check(quest)

func update_check(quest: QuestEntry):
	check.visible = quest.is_completed()

func update_progress(quest: QuestEntry):
	progress.text = "%d/%d" % [quest.get_metadata(QuestHandler._key.PROGRESS),quest.get_metadata(QuestHandler._key.REQUIRED)]
