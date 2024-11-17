class_name InventoryItem
extends TextureRect

@export var data: Item
var count: int
var c_label: Label ## Label for displaying count

func _init(d: Item, a: int):
	data = d
	count = a
	c_label = Label.new()
	add_child(c_label)
	display_count()
	
func _ready() -> void:
	expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	texture = data.texture
	tooltip_text = "%s" % [data.name]
	
func _get_drag_data(at_position: Vector2):
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
	var space_left = data.max_stack_size - count
	if amount < 0:
		pass
	elif amount > space_left:
		count+=space_left
		display_count()
		return amount-space_left
	else:
		count+=amount
		display_count()
	return 0

func remove(amount: int) -> int: #returns the number of not removed items
	var amount_to_remove = min(count, amount)
	count -= amount_to_remove
	if count <= 0:
		self.queue_free()
		return amount-amount_to_remove
	display_count()
	return 0

func display_count() -> void:
	if count > 1:
		c_label.text = str(count)
		c_label.visible = true
	else:
		c_label.visible = false
