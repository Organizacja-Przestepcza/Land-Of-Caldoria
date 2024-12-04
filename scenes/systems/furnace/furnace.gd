extends Interface
class_name Furnace
@onready var inventory: Inventory = %Inventory
@onready var recipe_list: ItemList = $MarginContainer/FurnaceContainer/RecipeContainer/RecipeList
@onready var ingredients_list: ItemList = $MarginContainer/FurnaceContainer/InventoryContainer/InventoryList


var inventory_list: Dictionary

class Ingredient:
	var item: Item
	var amount: int
	func _init(itm,amnt) -> void:
		item = itm
		amount = amnt

func open() -> void:
	super()
	update_recipe_list()
	inventory_list = inventory.to_list()

func update_recipe_list():
	recipe_list.clear()
	for recipe: FurnaceRecipe in ListLoader.furnace_recipes.values():
		recipe_list.add_item(recipe.result.name + " Amount: " + str(recipe.amount))
		recipe_list.set_item_metadata(recipe_list.item_count-1,recipe)

func _on_exit_button_pressed() -> void:
	close()

func _on_recipe_list_item_selected(index: int) -> void:
	update_ingredients_list(index)
	
func update_ingredients_list(index: int):
	ingredients_list.clear()
	var recipe: FurnaceRecipe = recipe_list.get_item_metadata(index)
	for ingredient in recipe.items.keys():
		var ingr = Ingredient.new(ingredient,recipe.items[ingredient])
		ingredients_list.add_item(ingr.item.name + " Amount: " + str(ingr.amount),null,false)
		ingredients_list.set_item_metadata(ingredients_list.item_count-1,ingr)

func _on_craft_button_pressed() -> void:
	var item_count = ingredients_list.item_count
	if item_count > 0:
		for i in range(item_count):
			var ingredient: Ingredient = ingredients_list.get_item_metadata(i)
			if ingredient.item not in inventory_list.keys() or inventory_list[ingredient.item] < ingredient.amount:
				print("not crafting")
				return
		for i in range(item_count):
			var ingredient: Ingredient = ingredients_list.get_item_metadata(i)
			inventory.remove_item(ingredient.item,ingredient.amount)
			print(ingredient)
			inventory_list[ingredient.item] -= ingredient.amount
		var t = recipe_list.get_selected_items()
		var recipe = recipe_list.get_item_metadata(t[0])
		inventory.add_item(recipe.result,recipe.amount)
		inventory_list = inventory.to_list()
