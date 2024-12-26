extends Node

signal enemy_killed(mob: String)
signal crop_harvested
signal player_attacked(mob: String, damage: int)
signal object_destroyed(object: Destroyable)
signal item_added(item: Item, amount: int)
