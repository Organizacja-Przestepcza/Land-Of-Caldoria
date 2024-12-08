extends Node
@onready var current_quest: QuestResource


# Store your kill count and target kill value
var current_kills: int = 0

# Connect to the signal when the Questify is initialized
func _ready():
	current_quest = preload("res://quests/wolf_task.tres")
	var instance = current_quest.instantiate()
	Questify.start_quest(instance)
	get_tree().connect("node_added", _on_node_added)
	Questify.condition_query_requested.connect(_on_condition_query_requested)
	

func _on_node_added(node: Node):
	# Check if the new node is an enemy
	if node.is_in_group("enemies"):
		print("New enemy detected: ", node.name)
		node.connect("enemy_killed", _on_enemy_killed)

# Handle the condition query
func _on_condition_query_requested(type: String, key: String, value: Variant, requester: QuestCondition):
	print(type)
	print(key)
	print(value)
	if type == "kill":
		if key == "wolf" and current_kills >= value:
			print("request")
			requester.set_completed(true)
			print("Quest completed! Killed enough enemies.")
			
func _on_enemy_killed(killed_count: int):
	current_kills = killed_count
	print("Updated kills: ", current_kills)
	# Inform Questify about the updated kill count])
