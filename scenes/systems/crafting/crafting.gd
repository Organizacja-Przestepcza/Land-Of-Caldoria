extends Control
class_name Crafting
@onready var inventory: Inventory = $"../Inventory"
@onready var game: Game = %Game

@onready var ingredients_list: ItemList = $MarginContainer/CraftingContainer/IngredientsContainer/IngredientsList
@onready var recipe_list: ItemList = $MarginContainer/CraftingContainer/RecipeContainer/RecipeList
var inventory_list: Dictionary

func open() -> void: 
	ingredients_list.grab_focus()
	game.state = Game.State.INVENTORY
	update_recipe_list()
	inventory_list = inventory.to_list()

func update_recipe_list():
	recipe_list.clear()
	for recipe: CraftingRecipe in ListLoader.crafting_recipes.values():
		if not recipe.result:
			print(recipe.id, " - item doesnt exist")
			continue
		recipe_list.add_item(recipe.result.name + " Amount: " + str(recipe.amount))
		recipe_list.set_item_metadata(recipe_list.item_count-1,recipe)

func _on_recipe_list_item_selected(index: int) -> void:
	update_ingredients_list(index)
	
func update_ingredients_list(index: int):
	ingredients_list.clear()
	var recipe: CraftingRecipe = recipe_list.get_item_metadata(index)
	for ingredient in recipe.items.keys():
		var ingr = Ingredient.new(ingredient,recipe.items[ingredient])
		if not ingr.item:
			print(ingredient, " doesnt exist")
			continue
		ingredients_list.add_item(ingr.item.name + " Amount: " + str(ingr.amount),null,false)
		ingredients_list.set_item_metadata(ingredients_list.item_count-1,ingr)

func _on_craft_button_pressed() -> void:
	var item_count = ingredients_list.item_count
	if item_count > 0:
		var t = recipe_list.get_selected_items()
		if t.size() < 1:return
		for i in range(item_count):
			var ingredient: Ingredient = ingredients_list.get_item_metadata(i)
			if ingredient.item not in inventory_list.keys() or inventory_list[ingredient.item] < ingredient.amount:
				print("not crafting")
				return
		for i in range(item_count):
			var ingredient: Ingredient = ingredients_list.get_item_metadata(i)
			inventory.remove_item(ingredient.item,ingredient.amount)
			
			inventory_list[ingredient.item] -= ingredient.amount
		
		var recipe = recipe_list.get_item_metadata(t[0])
		inventory.add_item(recipe.result,recipe.amount)
		inventory_list = inventory.to_list()


func _on_visibility_changed() -> void:
	if visible:recipe_list.grab_focus()
