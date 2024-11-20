class_name Player
extends CharacterBody2D

@export var speed = 40

@onready var interface: CanvasLayer = $Interface
@onready var hud: Hud = $Hud
@onready var hotbar: Hotbar = %Hotbar
@onready var build_manager: BuildManager = $"../BuildManager"
@onready var inventory: Inventory = $Interface/Inventory
@onready var health_bar: Health = hud.get_node("VBoxContainer/HealthBar")
@onready var hunger_bar: Hunger = hud.get_node("VBoxContainer/HungerBar")


var facing: Direction = Direction.Down

var health = 100
var hunger = 100
var attack_animation_scene = preload("res://scenes/player/attack_animation.tscn")

var reach = 30
var can_attack: bool = true
var attack_cooldown: float = 0.5

var nearest_interactable

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
	health_bar.modify_health(-value)

func effect_from_item(item: Consumable):
	if item.hunger_value != 0:
		hunger_bar.modify_hunger(item.hunger_value)
	if item.health_value != 0:
		health_bar.modify_health(item.health_value)

func get_victim(): 
	if !can_attack:
		return
	can_attack=false
	get_tree().create_timer(attack_cooldown).timeout.connect(func(): can_attack=true)
	var attack_animation: AnimatedSprite2D = attack_animation_scene.instantiate()
	attack_animation.position.y += 8
	var hitbox = ShapeCast2D.new()
	hitbox.shape = RectangleShape2D.new()
	hitbox.position = Vector2i(0,-16)
	hitbox.max_results = 3
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

func use_item() -> void:
	var held_item = hotbar.get_held_item()
	if held_item is Consumable:
		consume(hotbar.selected_slot.get_child(0),1)
	elif held_item == ItemLoader.name("hammer"):
		build_manager.build()
	elif held_item is Tool:
		attack(held_item)

func interact():
	if nearest_interactable is LootBag:
		for key in nearest_interactable.items.keys():
			inventory.add_item(key,nearest_interactable.items[key])
		nearest_interactable.queue_free()
	elif nearest_interactable is NPC:
		interface.get_node("Trading").open()

func attack(tool: Tool):
	var victim = await get_victim()
	if victim is Mob:
		if victim.take_damage(tool.damage) and victim.dropped_item:
			inventory.add_item(victim.dropped_item, 1)
	if victim is Destroyable:
		if victim.required_tool == hotbar.get_held_item() or victim.required_tool == null:
			if victim.take_damage(tool.damage) and victim.dropped_item:
				inventory.add_item(victim.dropped_item, 1)

func consume(item: InventoryItem, amount: int) -> void:
	if item.data is Consumable:
		effect_from_item(item.data)
		item.remove(amount)
