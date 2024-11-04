extends Resource
class_name SaveGame
const SAVE_GAME_DIR = "user://save/"

func write_save_game(name:String) -> String:
	print(name)
	var date = Time.get_datetime_string_from_system()
	var save_path
	if name.is_empty():
		save_path = str(WorldData.world_name + "_" + date + ".tscn")
	else:
		save_path = str(name+"_"+date+".tscn")
	var packed_save:PackedScene = PackedScene.new()
	packed_save.pack(WorldData)
	ResourceSaver.save(packed_save, SAVE_GAME_DIR + save_path)
	return save_path

static func save_exist(name:String) -> bool:
	return ResourceLoader.exists(name)
	
static func load_saved_game(name:String) -> Resource:
	return ResourceLoader.load(name,"",2)
	
static func load_saved_games() -> Array:
	var saved_games = []
	if not DirAccess.dir_exists_absolute(SAVE_GAME_DIR):
		DirAccess.make_dir_absolute(SAVE_GAME_DIR)
	var dir = DirAccess.open(SAVE_GAME_DIR)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir():
				saved_games.append(file_name)
			file_name = dir.get_next()
	else:
		print("Error occured")
	return saved_games
