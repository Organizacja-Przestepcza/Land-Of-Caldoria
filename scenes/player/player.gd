class_name Player
extends CharacterBody2D

@export var speed = 40
var facing: Direction = Direction.Down
@onready var hud = $Hud
var health = 100
var hunger = 100
var attack_animation_scene = preload("res://scenes/player/attack_animation.tscn")

var reach = 30
var can_attack: bool = true
var attack_cooldown: float = 0.5

enum Direction {Down, Up, Right, Left}

func get_input():
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_direction * speed
	if Input.is_action_pressed("sprint"):
		velocity = velocity * 2
		

func play_animation() -> void:
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	var animations: Array = ["walk_side", "walk_down", "walk_up", "run_side", "run_down", "run_up"]
	var i: int = 0
	if Input.is_action_pressed("sprint"):
		i = 3
	if velocity.x != 0:
		$AnimatedSprite2D.animation = animations[i]
		$AnimatedSprite2D.flip_h = velocity.x < 0
		facing = Direction.Left if velocity.x < 0 else Direction.Right
	elif velocity.y > 0:
		$AnimatedSprite2D.animation = animations[i+1]
		$AnimatedSprite2D.flip_h = 0
		facing = Direction.Down
	elif velocity.y < 0:
		$AnimatedSprite2D.animation = animations[i+2]
		$AnimatedSprite2D.flip_h = 0
		facing = Direction.Up

func _physics_process(delta):
	get_input()
	move_and_slide()
	play_animation()

func hit(value: int):
	print("hit received, damage: ", value)
	var healthbar: Health = hud.get_node("HealthBar")
	healthbar.modify_health(-value)

func effect_from_item(item: Consumable):
	if item.hunger_value != 0:
		var hungerbar: Hunger = hud.get_node("HungerBar")
		hungerbar.modify_hunger(item.hunger_value)
	if item.health_value != 0:
		var healthbar: Health = hud.get_node("HealthBar")
		healthbar.modify_health(item.health_value)

func attack():
	if !can_attack:
		return
	can_attack=false
	get_tree().create_timer(attack_cooldown).timeout.connect(func(): can_attack=true)
	var attack_animation: AnimatedSprite2D = attack_animation_scene.instantiate()
	attack_animation.position.y += 8
	var hitbox = ShapeCast2D.new()
	hitbox.shape = RectangleShape2D.new()
	hitbox.position = Vector2i(0,-16)
	hitbox.max_results = 1
	hitbox.collision_mask = 2+8
	match facing:
		Direction.Down:
			hitbox.shape.size.y = reach/2
			hitbox.shape.size.x = reach
			hitbox.target_position = Vector2(0,reach)
			attack_animation.rotate(-PI*1.5)
			attack_animation.position.y += 16
			attack_animation.position.x -= 16
		Direction.Up:
			hitbox.shape.size.y = reach/2
			hitbox.shape.size.x = reach
			hitbox.target_position = Vector2(0,-reach)
			attack_animation.rotate(PI*1.5)
			attack_animation.position.y -= 24
		Direction.Right:
			hitbox.shape.size.y = reach
			hitbox.shape.size.x = reach/2
			hitbox.target_position = Vector2(reach,0)
			attack_animation.position.x += 16
		Direction.Left:
			hitbox.shape.size.y = reach
			hitbox.shape.size.x = reach/2
			hitbox.target_position = Vector2(-reach,0)
			attack_animation.flip_h = true
			attack_animation.position.x -= 32
	hitbox.enabled = true
	add_child(hitbox)
	attack_animation.play()
	add_child(attack_animation)
	await get_tree().create_timer(0.2).timeout
	hitbox.queue_free()
	attack_animation.queue_free()
	if hitbox.is_colliding():
		return hitbox.get_collider(0)

func _on_death(cause: String) -> void:
	get_tree().change_scene_to_packed(load("res://scenes/ui/screen_of_death.tscn"))

func show_trade(npc: NPC) -> void:
	get_tree().paused = true
	$Hud/TradeInterface.visible = true
	$Hud/HealthBar.visible = false
	$Hud/HungerBar.visible = false
	$Hud/TradeInterface.update_lists(npc)
	await $Hud/TradeInterface/TextureRect/Button.pressed
	hide_trade()

func hide_trade() -> void:
	$Hud/TradeInterface.visible = false
	$Hud/HealthBar.visible = true
	$Hud/HungerBar.visible = true
	get_tree().paused = false
