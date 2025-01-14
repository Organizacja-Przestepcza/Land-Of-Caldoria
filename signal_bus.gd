extends Node

signal enemy_killed(mob: String)
signal crop_harvested
signal player_attacked(mob: String, damage: int)
signal object_destroyed(object: Destroyable)
signal item_added(item: Item, amount: int)
signal selected_item_changed(item: Item)
signal npc_dialog_opened(npc: NPC)
signal npc_killed(npc: NPC)
signal torso_item()
signal coins_changed(value: int)
