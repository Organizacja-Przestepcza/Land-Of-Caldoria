extends MarginContainer
class_name QuestTile

func _init(quest: QuestEntry) -> void:
	%Title.text = quest.get_title()
	%Objective.text = quest.get_description()
	pass

func set_completed():
	%Checkbox/Check.show()

func set_uncompleted():
	%Checkbox/Check.hide()
