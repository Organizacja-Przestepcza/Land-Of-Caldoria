class_name Item
extends Resource

enum Slot {MAIN, HEAD, ARMS, CHEST, LEGS, FEET}

@export var slot: Slot
@export var name: String
@export var weight: int
@export var texture: Texture2D
