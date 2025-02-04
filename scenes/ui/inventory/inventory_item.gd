class_name InventoryItem
extends TextureRect

@export var data: Item
var count: int
var durability: int =-1:
	get: return durability
	set(value): 
		durability = value
		tooltip_text = "%s\n%d/%d" % [data.name, durability, data.durability] 
var c_label: Label ## Label for displaying count

func _init(d: Item, a: int):
	data = d
	count = a
	if data is Tool or data is Armor:
		durability = data.durability
	SignalBus.item_added.emit(d,a)
	c_label = Label.new()
	add_child(c_label)
	display_count()
	
func _ready() -> void:
	expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	texture = data.texture
	if data is Tool or data is Armor:
		tooltip_text = "%s\n%d/%d" % [data.name, durability, data.durability] 
	else:
		tooltip_text = "%s" % [data.name]
	var inv_slot: InventorySlot = get_parent()
	if inv_slot.is_selected:
		SignalBus.selected_item_changed.emit(data)
	
func _get_drag_data(at_position: Vector2) -> InventoryItem:
	set_drag_preview(make_drag_preview(at_position))
	return self

func make_drag_preview(at_position: Vector2) -> Control:
	var t = TextureRect.new()
	t.texture = texture
	t.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	t.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	t.custom_minimum_size = size
	t.modulate.a = 0.5
	t.position = Vector2(-at_position)
	
	var c = Control.new()
	c.add_child(t)
	
	return c

func add(amount: int) -> int: ## If there are leftover items, returns their amount. Returns null in any other case.
	var space_left: int = data.max_stack_size - count
	var amount_to_add = min(amount,space_left)
	count+=amount_to_add
	SignalBus.item_added.emit(data,amount_to_add)
	display_count()
	if amount > amount_to_add:
		return amount-amount_to_add
	return 0

func remove(amount: int) -> int: ## Returns the number of not removed items
	var amount_to_remove = min(count, amount)
	count -= amount_to_remove
	SignalBus.item_added.emit(data,-amount_to_remove)
	display_count()
	if count <= 0:
		if get_parent().is_selected:
			SignalBus.selected_item_changed.emit(null)
		self.queue_free()
		return amount-amount_to_remove
	return 0

func display_count() -> void:
	if count > 1:
		c_label.text = str(count)
		c_label.visible = true
	else:
		c_label.visible = false
		
func decrease_durability(value: int) -> void:
	if not data is Tool and not data is Armor:
		return
	var final_durability_decrease_value = clampi(value + WorldData.difficulty - 2, 1, 3)
	durability -= final_durability_decrease_value
	if durability <=0:
		remove(1)

func repair():
	if not data is Tool and not data is Armor:
		return
	durability=data.durability
	
