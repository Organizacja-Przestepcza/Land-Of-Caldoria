class_name Ranged
extends Item

@export var durability: int
@export var knockback: int
@export var range: float
@export var cooldown: float
@export var ammo_list: Array[Item]
@export var damage_list: Array[int]
var selected_ammo_idx: int
