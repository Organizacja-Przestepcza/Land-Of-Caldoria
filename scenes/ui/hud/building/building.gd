extends Control
class_name BuildMenu

@onready var hud: Hud = self.get_parent()
@onready var build_list: ItemList = $MarginContainer/BuildingContainer/BuildList
var selected_item: int = 0
var inventory: Dictionary

func open() -> void:
	self.visible = true
	hud.state = hud.State.INVENTORY
	inventory = hud.inventory_to_list()
	#update_build_list()

func close() -> void:
	self.visible = false
	hud.state = hud.State.PLAYING

func update_build_list():
	build_list.clear()
	for recipe: BuildRecipe in ListLoader.build_recipes.values():
		build_list.add_item(recipe.result)
		build_list.set_item_metadata(build_list.item_count-1,recipe)

func _on_exit_button_pressed() -> void:
	close()


func _on_build_list_item_selected(index: int) -> void:
	selected_item = index
