extends Node2D
class_name ProcWorld

@onready var noise_generator: NoiseGenerator = $NoiseGenerator
@onready var player: Player = %Player
@onready var threaded_chunk_loader_2d: ThreadedChunkLoader2D = $NoiseGenerator/ThreadedChunkLoader2D

func _ready() -> void:
	var user_seed = WorldData.seed
	get_tree().paused = false

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_V and event.echo == false and event.pressed == true:
			print("loaded chunks:", noise_generator.generated_chunks)
			var chunk = noise_generator.map_to_chunk(noise_generator.global_to_map(player.position))
			print("player is in: ", chunk, "  is loaded? ", noise_generator.has_chunk(chunk))
			print("---")
