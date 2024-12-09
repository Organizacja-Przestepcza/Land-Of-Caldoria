extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func update() -> void:
	for quest in Questify.get_quests():
		var label = Label.new()
		label.text = "\tQuest: %s \nDescription: %s \nCompleted: %s\n" % [quest.name, quest.description, quest.completed]
		$VBoxContainer.add_child(label)
	
func open() -> void:
	update()
