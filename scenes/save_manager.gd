extends Resource
class_name SaveManager
const SAVE_GAME_DIR = "user://save/"
static var saves = []

func create_save_data() -> SaveData:
	var world: ProcWorld = WorldData.player.get_parent()
	var s = SaveData.new()
	s.world_name = WorldData.world_name
	s.inventory = WorldData.player.inventory.get_data()
	s.player_global_position = WorldData.player.global_position
	s.seed = WorldData.seed
	s.size = WorldData.size
	s.time = Time.get_datetime_string_from_system()
	world.save_loaded_chunks_objects()
	s.objects = world.object_tiles.duplicate(true)
	return s

func save(name:String) -> String:
	var save_path
	if name.is_empty():
		save_path = str(WorldData.world_name +".tres")
	else:
		save_path = str(name + ".tres")
	var data = create_save_data()
	var error = ResourceSaver.save(data, SAVE_GAME_DIR + save_path)
	if error:
		print(error)
	return save_path
	
static func load_game(name:String) -> Resource:
	if not ResourceLoader.exists(SAVE_GAME_DIR + name + ".tres"):
		return
	return ResourceLoader.load(SAVE_GAME_DIR + name + ".tres")

static func remove_save(name: String) -> Error: # returns true if succesful
	var err = DirAccess.remove_absolute(SAVE_GAME_DIR + name + ".tres")
	return err

static func load_all() -> void:
	saves.clear()
	if not DirAccess.dir_exists_absolute(SAVE_GAME_DIR):
		DirAccess.make_dir_absolute(SAVE_GAME_DIR)
	var dir = DirAccess.open(SAVE_GAME_DIR)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir():
				saves.append(file_name)
			file_name = dir.get_next()
	else:
		print("Error occured")
