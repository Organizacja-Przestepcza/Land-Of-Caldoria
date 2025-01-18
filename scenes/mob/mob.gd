extends CharacterBody2D
class_name Mob
var player: Player
var world: ProcWorld
var health: int 
var dropped_item: Item
var exp: int = 1
var mob_name

func _ready() -> void:
	world = get_parent()
	world.chunk_loader.chunk_changed.connect(despawn)
	player = WorldData.player
	if has_node("HealthBar"):
		$HealthBar.max_value = health
		$HealthBar.hide()

func despawn(_chunk_position):
	var dist_to_player = self.global_position.distance_squared_to(player.global_position)
	if dist_to_player > 3000000:
		world.chunk_loader.chunk_changed.disconnect(despawn)
		queue_free()

func handle_healthbar():
	if has_node("HealthBar"):
		$HealthBar.visible = true
		$HealthBar.value = health
