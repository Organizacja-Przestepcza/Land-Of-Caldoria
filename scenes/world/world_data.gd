extends Node

enum Difficulty {EASY=0, NORMAL=1, HARD=3, NIGHTMARE=5}

var world_name: String = "Default World"
var size: int = -1
var seed: int = -1
var player: Player
var load: Resource
var is_black: bool = false
var difficulty: Difficulty = Difficulty.NORMAL
