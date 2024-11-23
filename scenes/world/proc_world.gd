extends Node2D
class_name ProcWorld

@onready var noise_generator: NoiseGenerator = $NoiseGenerator
@onready var player: Player = %Player
@onready var chunk_loader_2d: ChunkLoader2D = $NoiseGenerator/ChunkLoader2D

func _ready() -> void:
	var user_seed = WorldData.seed
	get_tree().paused = false
