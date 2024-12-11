extends Node
@onready var current_quest: QuestResource


# Store your kill count
var current_kills: int = 0

# Connect to the signal when the Questify is initialized
func _ready():
	current_quest = preload("res://quests/wolf_task.tres")
	var instance = current_quest.instantiate()
	Questify.start_quest(instance)
	get_tree().connect("node_added", _on_node_added)
	Questify.condition_query_requested.connect(_on_condition_query_requested)
	

func _on_node_added(node: Node):
	if node.is_in_group("enemies") and node.name == "Wolf":
		print("New enemy detected: ", node.name)
		node.connect("enemy_killed", _on_enemy_killed)


func _on_condition_query_requested(type: String, key: String, value: Variant, requester: QuestCondition):
	if type == "kill":
		if key == "wolf" and current_kills >= value:
			requester.set_completed(true)
			print("Quest completed! Killed enough enemies.")
			
func _on_enemy_killed(mob_name: String):
	if mob_name == "Wolf":
		current_kills += 1
	print("Updated kills: ", current_kills)
