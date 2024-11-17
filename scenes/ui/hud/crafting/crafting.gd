extends Control
class_name Crafting

@onready var hud: Hud = self.get_parent()
@onready var ingredients_list: ItemList = $MarginContainer/CraftingContainer/IngredientsContainer/IngredientsList
@onready var recipe_list: ItemList = $MarginContainer/CraftingContainer/RecipeContainer/RecipeList
var inventory: Dictionary

class Ingredient:
	var item: Item
	var amount: int
	func _init(itm,amnt) -> void:
		item = itm
		amount = amnt

func open_crafting() -> void:
	self.visible = true
	inventory = hud.inventory_to_list()
	ingredients_list.clear()
	update_recipe_list()

func update_recipe_list():
	recipe_list.clear()
	for recipe: CraftingRecipe in ListLoader.crafting_recipes.values():
		recipe_list.add_item(recipe.result.name + " Amount: " + str(recipe.amount))
		recipe_list.set_item_metadata(recipe_list.item_count-1,recipe)

func _on_exit_button_pressed() -> void:
	self.visible = false

func _on_recipe_list_item_selected(index: int) -> void:
	update_ingredients_list(index)
	
func update_ingredients_list(index: int):
	var recipe: CraftingRecipe = recipe_list.get_item_metadata(index)
	for ingredient in recipe.items.keys():
		var ingr = Ingredient.new(ingredient,recipe.items[ingredient])
		ingredients_list.add_item(ingr.item.name + " Amount: " + str(ingr.amount),null,false)
		ingredients_list.set_item_metadata(ingredients_list.item_count-1,ingr)

func _on_craft_button_pressed() -> void:
	var item_count = ingredients_list.item_count
	if item_count > 0:
		for i in range(item_count):
			var ingredient: Ingredient = ingredients_list.get_item_metadata(i)
			if ingredient.item not in inventory.keys() or inventory[ingredient.item] != ingredient.amount:
				print("not crafting")
				return
		for i in range(item_count):
			var ingredient: Ingredient = ingredients_list.get_item_metadata(i)
			hud.remove_item(ingredient.item,ingredient.amount)
		var t = recipe_list.get_selected_items()
		var recipe = recipe_list.get_item_metadata(t[0])
		hud.add_item(recipe.result,recipe.amount)
