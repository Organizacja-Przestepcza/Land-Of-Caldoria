extends TabContainer

enum TabName {
	Inventory,
	Crafting,
	Building,
	Stats
}

func open(tab: TabName) -> void:
	open_tab(tab)
	%Game.state = Game.State.INVENTORY
	get_tree().paused = true
	self.visible = true
	self.current_tab = tab
	
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
func close() -> void:
	$Inventory.close()
	%Game.state = Game.State.PLAYING
	get_tree().paused = false
	self.visible = false


func _on_tab_changed(tab: int) -> void:
	open_tab(tab)
