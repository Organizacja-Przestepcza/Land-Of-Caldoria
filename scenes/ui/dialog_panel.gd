extends BoxContainer
class_name DialogPanel

func _ready() -> void:
	SignalBus.npc_dialog_opened.connect(start_dialog)
	

func start_dialog(npc: NPC):
	pass 
