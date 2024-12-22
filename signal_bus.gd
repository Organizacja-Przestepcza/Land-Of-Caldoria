extends Node

signal enemy_killed(mob: String)
signal crop_harvested
signal quest_started(type: Quests.Type)
signal player_attacked(mob: String, damage: int)
signal object_destroyed(object: Destroyable)
