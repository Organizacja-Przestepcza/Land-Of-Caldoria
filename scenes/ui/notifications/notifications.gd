extends ItemList
@onready var notifications: ItemList = $"."
enum MessageType {
	DANGER,
	INFO,
	WARNING
}
var active_notifications = []
var message_colors = {
	MessageType.DANGER: Color.RED,
	MessageType.INFO: Color.BLUE,
	MessageType.WARNING: Color.YELLOW
}
func get_message_color(message_type):
	return message_colors.get(message_type, Color.BLACK) 
	
func _ready() -> void:
	add_notification("Destroyed tree: +2 logs +1 stick", MessageType.DANGER)
	await get_tree().create_timer(2).timeout
	add_notification("Destroyed tree: +2 logs +1 stick", MessageType.INFO)
	await get_tree().create_timer(2).timeout
	add_notification("Destroyed tree: +2 logs +1 stick", MessageType.WARNING)
	

func add_notification(message: String, type: MessageType) -> void:
	var color = get_message_color(type)
	var idx = notifications.add_item(message)
	notifications.set_item_custom_bg_color(idx, color)
	active_notifications.append(idx)  # Store the index
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
