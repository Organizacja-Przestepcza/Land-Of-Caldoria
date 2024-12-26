extends Control
class_name InteractionDialog

signal npc_trade
signal npc_quest

func _on_trade_pressed() -> void:
	npc_trade.emit()


func _on_quest_pressed() -> void:
	npc_quest.emit()
