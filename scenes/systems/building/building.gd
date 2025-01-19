extends Control
class_name BuildMenu

@onready var build_list: ItemList = $MarginContainer/BuildingContainer/BuildList
@onready var inventory: Inventory = $"../Inventory"
var selected_item: int = -1
var can_build: bool = false

var inventory_list

func open() -> void:
	update_build_list()
	build_list.grab_focus()
func update_build_list():
	build_list.clear()
	for recipe: BuildRecipe in ListLoader.build_recipes.values():
		build_list.add_item(recipe.name)
		var tooltip: String = "Required materials:\n"
		for item: Item in recipe.items:
			tooltip += item.name + " " + str(recipe.items.get(item, 0)) + "\n"
		build_list.set_item_tooltip(build_list.item_count-1,tooltip)
		build_list.set_item_metadata(build_list.item_count-1,recipe)

func _on_exit_button_pressed() -> void:
	get_parent().close()


func _on_build_list_item_selected(index: int) -> void:
	selected_item = index
	can_build = has_required_ingredients()

func has_required_ingredients() -> bool:
	inventory_list = inventory.to_list()
	var recipe = build_list.get_item_metadata(selected_item)
	if recipe is BuildRecipe:
		var item_arr: Array = recipe.items.keys()
		if not item_arr.is_empty():
			for i in range(item_arr.size()):
				var item_name = item_arr[i]
				if item_name not in inventory_list.keys() or inventory_list[item_name] < recipe.items.get(item_name):
					return false
		return true
	push_error("recipe is not BuildRecipe")
	return false

func use_ingredients():
	if not has_required_ingredients():
		return
	var recipe = build_list.get_item_metadata(selected_item)
	if recipe is BuildRecipe:
		var item_arr: Array = recipe.items.keys()
		if not item_arr.is_empty():
			for i in range(item_arr.size()):
				var item_name = item_arr[i]
				inventory.remove_item(item_name,recipe.items.get(item_name))
			inventory_list = inventory.to_list()

func get_current_recipe() -> BuildRecipe:
	if not selected_item == -1:
		var recipe = build_list.get_item_metadata(selected_item)
		if recipe is BuildRecipe:
			return recipe
	return null


func _on_visibility_changed() -> void:
	if visible :build_list.grab_focus()
