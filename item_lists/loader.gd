extends Node

var lists

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
				if file_name.get_extension() != "tres":
					file_name = dir.get_next()
					continue
				var item_list = load(path + file_name)
				lists[item_list] = item_list
			file_name = dir.get_next()
	else:
		printerr("Error: Couldn't open " + path)
