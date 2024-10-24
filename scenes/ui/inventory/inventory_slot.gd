class_name InventorySlot
extends PanelContainer

@export var type: Type

enum Type {MAIN, HEAD, ARMS, TORSO, LEGS, FEET}

func _init(t: Type, cms: Vector2) -> void:
	type = t
	custom_minimum_size = cms
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
