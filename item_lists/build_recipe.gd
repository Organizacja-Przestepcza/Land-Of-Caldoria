extends Resource
class_name BuildRecipe

enum Layer {Floor, Object}

var id: String ## for now does nothing
var layer: Layer
var is_terrain: bool ## [code]true[/code] if the tile is a BetterTerrain terrain
var source: int ## not necessary if [member is_terrain] is [code]true[/code]
var result ## [code]int[/code] terrain source if [member is_terrain] is [code]true[/code][br][code]int[/code] alt_tile if scene collection[br][code]Vector2i[/code] atlas coords otherwise
var items: Dictionary ## dictionary structure[br][code]item: Item - amount:int[/code] 
