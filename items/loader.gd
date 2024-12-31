extends Node


@export var items: Dictionary = {}

func _ready() -> void:
	load_all_items("res://items/")
	
func load_all_items(path: String):
	var dir = DirAccess.open(path)
	if DirAccess.get_open_error() == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				load_all_items(dir.get_current_dir() +"/"+ file_name + "/")
			else:
				if file_name.get_extension() != "tres":
					file_name = dir.get_next()
					continue
				var item = load(path + file_name)
				if item:
					items[item.name.to_lower().replace(" ", "_")] = item
			file_name = dir.get_next()
	else:
		printerr("Error: Couldn't open " + path)

func name(n: String) -> Item:
	n = n.to_lower().replace(" ", "_")
	if n in items.keys():
		return items[n]
	return null
