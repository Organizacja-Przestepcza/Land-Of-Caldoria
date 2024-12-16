extends Node
class_name QuestManager

var current_quest: QuestResource
var quest_resources: Dictionary = {
	"kill_mobs": preload("res://quests/kill_mobs.tres")
}

var active_quests: Array[QuestResource]

var current_kills: int = 0

func _ready():
	get_tree().connect("node_added", _on_node_added)
	#var instance = current_quest.instantiate()
	#Questify.start_quest(instance)
	#Questify.condition_query_requested.connect(_on_condition_query_requested)

func new_quest():
	
	pass

func _on_node_added(node: Node):
	if node is Enemy:
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
