extends Node2D

@export var height_noise: NoiseTexture2D
@export var map_size: int = 256

var noise: Noise

var sand_tiles: Array = []
var sand_terrain_id: int = 1

func _ready() -> void:
	noise = height_noise.noise
	generate_world()
	
func generate_world() -> void:
	var map_range: Array = range(-map_size/2, map_size/2)
	for x in map_range:
		for y in map_range:
			var noise_val: float = noise.get_noise_2d(x,y)
			
