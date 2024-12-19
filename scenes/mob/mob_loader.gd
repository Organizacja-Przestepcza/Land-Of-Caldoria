extends Node

var enemies: Dictionary = {
	"bat": preload("res://scenes/mob/enemy/bat.tscn"),
	"bear": preload("res://scenes/mob/enemy/bear.tscn"),
	"boar": preload("res://scenes/mob/enemy/boar.tscn"),
	"crab": preload("res://scenes/mob/enemy/crab.tscn"),
	"slime": preload("res://scenes/mob/enemy/slime.tscn"),
	"spider": preload("res://scenes/mob/enemy/spider.tscn"),
	"wolf": preload("res://scenes/mob/enemy/wolf.tscn")
}
var neutrals: Dictionary = {
	"sheep": preload("res://scenes/mob/neutral/sheep.tscn")
}

func get_enemy(mob_name: String):
	mob_name = mob_name.to_lower()
	return enemies.get(mob_name)

func get_neutral(mob_name: String):
	mob_name = mob_name.to_lower()
	return neutrals.get(mob_name)

func get_mob(mob_name: String):
	mob_name = mob_name.to_lower()
	if enemies.has(mob_name):
		return enemies.get(mob_name)
	if neutrals.has(mob_name):
		return neutrals.get(mob_name)
	return null
