extends ItemList
class_name Notifications
@onready var notifications: ItemList = $"."

var active_notifications = []

func _ready() -> void:
	SignalBus.player_attacked.connect(_on_player_attacked)

func _on_player_attacked(mob: String, damage: int):
	add_notification(mob+" hit player: -"+ str(damage) + "hp")

func add_notification(message: String) -> void:
	var idx = notifications.add_item(message)
	notifications.set_item_tooltip_enabled(idx,false)
	notifications.set_item_selectable(idx,false)
	active_notifications.append(idx) 
	await remove_notification()

func remove_notification() -> void:
	await get_tree().create_timer(3).timeout
	if active_notifications.size() > 0:
		var idx = active_notifications[0]
		notifications.remove_item(0)
		active_notifications.pop_front()
