extends TabContainer

@onready var game = %Game

enum TabName {
	Inventory,
	Crafting,
	Building,
	Stats,
	Quests
}

func open(tab: TabName) -> void:
	open_tab(tab)
	game.state = Game.State.INVENTORY
	visible = true
	current_tab = tab
	
func open_tab(tab:TabName) -> void:
	match tab:
		TabName.Inventory:
			$Inventory.open()
		TabName.Crafting:
			$Crafting.open()
		TabName.Building:
			$Building.open()
		TabName.Stats:
			$Stats.open()
		TabName.Quests:
			$Quests.open()
			
func close() -> void:
	$Inventory.close()
	game.state = Game.State.PLAYING
	visible = false


func _on_tab_changed(tab: int) -> void:
	open_tab(tab)
