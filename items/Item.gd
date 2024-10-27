class_name Item
extends Resource

enum Type { HEAD, CHEST, LEGS, FEET, ACCESSORY, MAIN }

@export var type: Type
@export var slot: InventorySlot.Type
@export var name: String
@export var weight: int
@export var texture: Texture2D
@export var description: String
