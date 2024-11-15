extends Node

var lists : Dictionary = {
	
}

func _ready() -> void:
	load_all_lists("res://item_lists/")

func load_all_lists(path: String):
	var dir = DirAccess.open(path)
	if DirAccess.get_open_error() == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				load_all_lists(dir.get_current_dir() +"/"+ file_name + "/")
			else:
				if file_name == "loader.gd":
					file_name = dir.get_next()
					continue
				var script: GDScript = load(path + file_name)
				var list: Resource = script.new()
				lists[list.id] = list.items
			file_name = dir.get_next()
	else:
		printerr("Error: Couldn't open " + path)
