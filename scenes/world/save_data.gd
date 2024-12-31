extends Resource
class_name SaveData

@export var world_name: String
@export var size: int = 64
@export var seed: int = -1
@export var inventory: Dictionary
@export var player_global_position: Vector2
@export var time: String
@export var buildings: PackedByteArray
@export var objects: Dictionary
@export var floors: Dictionary
@export var quests: Array[Dictionary]
@export var caves: Dictionary
