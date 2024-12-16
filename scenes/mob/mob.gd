extends CharacterBody2D
class_name Mob
var notifications
var player: Player
var world: ProcWorld
var health: int 
var dropped_item: Item
var exp: int = 1
var mob_name

func _ready() -> void:
	world = get_parent()
	world.chunk_loader.chunk_changed.connect(despawn)
	if get_tree().root.has_node("World/Player"):
		player = get_tree().root.get_node("World/Player")
	elif get_tree().root.has_node("CaveManager/Player"):
		player = get_tree().root.get_node("CaveManager/Player")
	notifications = player.notifications

func despawn(_chunk_position):
	var dist_to_player = self.global_position.distance_squared_to(player.global_position)
	if dist_to_player > 3000000:
		world.chunk_loader.chunk_changed.disconnect(despawn)
		queue_free()

func handle_healthbar():
	print(mob_name)
