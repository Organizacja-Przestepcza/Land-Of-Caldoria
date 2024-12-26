extends Node

var enemies: Dictionary = {
	"bear": preload("res://scenes/mob/enemy/bear.tscn"),
	"boar": preload("res://scenes/mob/enemy/boar.tscn"),
	"crab": preload("res://scenes/mob/enemy/crab.tscn"),
	"slime": preload("res://scenes/mob/enemy/slime.tscn"),
	"wolf": preload("res://scenes/mob/enemy/wolf.tscn")
}
var neutrals: Dictionary = {
	"sheep": preload("res://scenes/mob/neutral/sheep.tscn")
}

func get_random_enemy_name() -> String:
	return enemies.keys().pick_random()
	
func get_random_enemy() -> Enemy:
	var mob_name = enemies.keys().pick_random()
	return enemies.get(mob_name).instantiate()

func get_enemy(mob_name: String) -> Enemy:
	mob_name = mob_name.to_lower()
	var enemy = enemies.get(mob_name)
	if enemy is PackedScene:
		return enemy.instantiate()
	return null

func get_neutral(mob_name: String) -> Neutral:
	mob_name = mob_name.to_lower()
	var neutral = neutrals.get(mob_name)
	if neutral is PackedScene:
		return neutral.instantiate()
	return null

func get_mob(mob_name: String) -> Mob:
	mob_name = mob_name.to_lower()
	if enemies.has(mob_name):
		return enemies.get(mob_name).instantiate()
	if neutrals.has(mob_name):
		return neutrals.get(mob_name).instantiate()
	return null
