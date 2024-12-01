extends ItemList
class_name Notifications
@onready var notifications: ItemList = $"."

var active_notifications = []

func add_notification(message: String) -> void:

	var idx = notifications.add_item(message)
	notifications.set_item_tooltip_enabled(idx,false)
	notifications.set_item_selectable(idx,false)
	active_notifications.append(idx)  
	print("Added:", idx)
	await remove_notification()

func remove_notification() -> void:
	await get_tree().create_timer(3).timeout
	if active_notifications.size() > 0:
		var idx = active_notifications[0]
		notifications.remove_item(0)
		active_notifications.pop_front()
		print("Removed:", idx)
	print("Active notifications after removal:", active_notifications)
