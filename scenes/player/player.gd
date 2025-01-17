class_name Player
extends CharacterBody2D
enum State {
	IDLE,
	WALK,
	SPRINT,
	SWIM
}

@export var speed = 80
@export var camera_zoom = Vector2(2.2,2.2)

@onready var interface: CanvasLayer = $Interface
@onready var hud: Hud = $Hud
@onready var stamina_bar:Stamina = $Hud/VBoxContainer/StaminaBar
@onready var hotbar: Hotbar = %Hotbar
@onready var money: Money = $Interface/Trading.money_counter
@onready var game: Game = %Game

@onready var build_manager: BuildManager = $"../BuildManager"
@onready var cave_manager: CaveManager = $"../CaveManager"
@onready var farming_manager: FarmingManager = $"../FarmingManager"

@onready var inventory: Inventory = %Inventory
@onready var health_bar: Health = hud.get_node("VBoxContainer/HealthBar")
@onready var hunger_bar: Hunger = hud.get_node("VBoxContainer/HungerBar")
@onready var stats: Stats = %Stats
@onready var notifications: Notifications = %Notifications
@onready var ammo_selector: AmmoSelector = $Interface/AmmoSelector
@onready var point_light: PointLight2D = $PointLight2D

var state: State = State.IDLE

var facing: Direction = Direction.Down

var max_health: int = 100
var health: int = 100
var max_hunger: int = 100
var hunger: int = 100
var max_stamina: int = 100
var stamina: int = 100
var exp: int = 0
var level: int = 1
var attack_animation_scene = preload("res://scenes/player/attack_animation.tscn")
var bullet_scene = preload("res://scenes/systems/shooting/bullet.tscn")

var reach = 30
var can_attack: bool = true
var attack_cooldown: float = 0.5
@onready var sprite = $AnimatedSprite2D
var nearest_interactable:
	get:
		return nearest_interactable
	set(val):
		if nearest_interactable is Node:
			var children: Array = nearest_interactable.get_children()
			var old = children.filter(func(element): return element is Label).front()
			if old is Label:
				old.queue_free()
		if val is Node:
			var lbl := Label.new()
			lbl.text = InputMap.action_get_events("LC_interact").filter(func(action): return action is InputEventKey or action is InputEventMouseButton).front().as_text().get_slice("(",0)
			val.add_child(lbl)
		nearest_interactable = val

enum Direction {Down, Up, Right, Left}

func _ready() -> void:
	update_zoom(camera_zoom)
	WorldData.player = self
	
	if WorldData.is_black:
		sprite = $BlackAnimatedSprite2D
	sprite.visible = true
	
	SignalBus.selected_item_changed.connect(turn_on_light)
	
	QuestHandler.quest_started.emit(QuestHandler.quest_manager.add_quest("Where am i?","Find a way ouf of this place"))

func turn_on_light(item: Item):
	point_light.visible = item == ItemLoader.name("lamp")
	

func update_zoom(zoom):
	if zoom is Vector2:
		$Camera2D.zoom = zoom

func get_input():
	if game.state != Game.State.PLAYING:
		return
	var input_direction = Input.get_vector("LC_move_left", "LC_move_right", "LC_move_up", "LC_move_down")
	velocity = input_direction * speed
	if velocity == Vector2.ZERO:
		state = State.IDLE
		return
	if get_parent().has_method("is_only_water") and get_parent().is_only_water(position):
			state = State.SWIM
			velocity = velocity * 0.8 if stamina > 0 else velocity * 0.4
	elif Input.is_action_pressed("LC_sprint") and stamina > 0:
		velocity = velocity * 2
		state = State.SPRINT
	else:
		state = State.WALK

func play_animation() -> void:
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		sprite.play()
		$AudioStreamPlayer.stream_paused = false
	else:
		sprite.stop()
		$AudioStreamPlayer.stream_paused = true
	var animations: Array = ["walk_side", "walk_down", "walk_up", "run_side", "run_down", "run_up", "water_side", "water_down", "water_up"]
	var i: int 
	if state == State.SWIM:
		i=6
	elif state == State.SPRINT:
		i=3
	if velocity.x != 0:
		sprite.animation = animations[i]
		sprite.flip_h = velocity.x < 0
		facing = Direction.Left if velocity.x < 0 else Direction.Right
	elif velocity.y > 0:
		sprite.animation = animations[i+1]
		sprite.flip_h = 0
		facing = Direction.Down
	elif velocity.y < 0:
		sprite.animation = animations[i+2]
		sprite.flip_h = 0
		facing = Direction.Up

func _physics_process(_delta):
	get_input()
	move_and_slide()
	play_animation()

func hit(value: int):
	var armor_protection: int = 0
	var armor_array = inventory.get_armor()
	for armor_piece in armor_array:
		if armor_piece is Armor:
			armor_protection += armor_piece.protection
	print("protection: ", armor_protection)
	var effective_protection = armor_protection * 0.5
	var damage_to_player = max(1, value - effective_protection)
	print("hit received, damage: ", damage_to_player)
	health_bar.modify_health(-damage_to_player)

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
	hitbox.collision_mask = 2+8+16
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
	var held_item = hotbar.get_held_inventory_item()
	if not held_item: 
		return
	if held_item.data == ItemLoader.name("hammer"):
		build_manager.build()
	elif held_item.data == ItemLoader.name("shovel"):
		cave_manager.dig()
	elif held_item.data == ItemLoader.name("hoe"):
		if not farming_manager.till_ground():
			farming_manager.harvest()
	elif held_item.data == ItemLoader.name("shears"):
		print_debug("shears")
	elif held_item.data == ItemLoader.name("bucket"):
		farming_manager.fill_bucket()
	elif held_item.data == ItemLoader.name("water_bucket"):
		farming_manager.water_crop()
	elif held_item.data  is Consumable:
		consume(hotbar.selected_slot.get_child(0),1)
	elif held_item.data  is Ranged:
		shoot(held_item.data)
	elif held_item.data  is Tool:
		var tmp = await attack(held_item.data)
		
		if tmp:
			held_item.decrease_durability(1)
			print(held_item.durability)

func interact():
	if nearest_interactable is LootBag:
		for key in nearest_interactable.items.keys():
			inventory.add_item(key,nearest_interactable.items[key])
		nearest_interactable.queue_free()
	elif nearest_interactable is NPC:
		nearest_interactable.open_dialog()
	elif nearest_interactable is FurnaceObj:
		interface.get_node("Furnace").open()
	elif farming_manager.is_on_field(position):
		farming_manager.plant_seed(hotbar.get_held_item(), position)
	elif cave_manager.is_valid_entry(position): # check if there is a hole under player
		cave_manager.enter()
	elif cave_manager.is_valid_exit(position):
		cave_manager.leave()

func attack(tool: Tool):
	attack_cooldown = tool.cooldown if tool.cooldown else 0.5
	var victim = await get_victim()
	if victim:
		damage_victim(victim, tool.damage)
		return true
	
func damage_victim(victim, damage):
	if victim is Mob:
		if victim.take_damage(damage):
			var total_exp = victim.exp + roundi(((victim.exp * level)/10)-1)
			stats.add_exp(total_exp)
			notifications.add_notification("Killed %s : + %d exp"%[victim.mob_name,total_exp])
			if victim.dropped_item:
				inventory.add_item(victim.dropped_item, 1)
	elif victim is Destroyable:
		if victim.required_tool == hotbar.get_held_item() or victim.required_tool == null:
			if victim.take_damage(damage):
				var tile_pos = victim.get_parent().local_to_map(victim.global_position)
				if get_parent().has_method(&"delete_object_at"):
					get_parent().delete_object_at(tile_pos)
				inventory.add_item(victim.get_drop(), 1)
	elif victim is NPC:
		if victim.take_damage(damage):
			print("kill")
	
func consume(item: InventoryItem, amount: int) -> void:
	if item.data is Consumable:
		effect_from_item(item.data)
		notifications.add_notification("Used "+ item.data.name)
		item.remove(amount)

func shoot(weap: Ranged):
	if not inventory.find_item(ammo_selector.get_current_ammo()):
		return
	var mouse_pos = get_global_mouse_position()
	var bullet_instance: Bullet = bullet_scene.instantiate()
	bullet_instance.collision_mask -= 1
	var offset: Vector2
	match facing:
		Direction.Up: 
			offset = Vector2(0, -32)
			if mouse_pos.y > global_position.y:
				return
		Direction.Down: 
			offset = Vector2(0, 0)
			if mouse_pos.y < global_position.y:
				return
		Direction.Right: 
			offset = Vector2(6, -24)
			if mouse_pos.x < global_position.x:
				return
		Direction.Left: 
			offset = Vector2(-6, -24)
			if mouse_pos.x > global_position.x:
				return
	bullet_instance.position = global_position + offset
	bullet_instance.set_direction_towards(mouse_pos)
	var ammo_idx = weap.ammo_list.find(ammo_selector.get_current_ammo())
	bullet_instance.damage = weap.damage_list[ammo_idx]
	bullet_instance.hit.connect(_on_bullet_hit)
	inventory.remove_item(ammo_selector.get_current_ammo(), 1)
	get_tree().current_scene.add_child(bullet_instance)

func throw(item: Item):
	if not item.is_throwable:
		return
	var mouse_pos = get_global_mouse_position()
	var bullet_instance: Bullet = bullet_scene.instantiate()
	bullet_instance.collision_mask -= 1
	var offset: Vector2
	match facing:
		Direction.Up: 
			offset = Vector2(0, -32)
			if mouse_pos.y > global_position.y:
				return
		Direction.Down: 
			offset = Vector2(0, 0)
			if mouse_pos.y < global_position.y:
				return
		Direction.Right: 
			offset = Vector2(6, -24)
			if mouse_pos.x < global_position.x:
				return
		Direction.Left: 
			offset = Vector2(-6, -24)
			if mouse_pos.x > global_position.x:
				return
	bullet_instance.position = global_position + offset
	bullet_instance.set_direction_towards(mouse_pos)
	bullet_instance.damage = item.weight
	bullet_instance.hit.connect(_on_bullet_hit)
	inventory.remove_item(item, 1)
	get_tree().current_scene.add_child(bullet_instance)
	
func _on_bullet_hit(body: Node, damage: int):
	if body is Mob or body is NPC:
		damage_victim(body, damage)


func _on_hotbar_item_selected(item: Item) -> void:
	if item is Ranged:
		ammo_selector.update_ammo_list_for_item(item)
