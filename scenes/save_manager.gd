extends Resource
class_name SaveManager
const SAVE_GAME_DIR = "user://save/"
#var hud: Hud

func create_save_data() -> SaveData:
	var s = SaveData.new()
	s.world_name = WorldData.world_name
	s.inventory = WorldData.player.hud.get_inventory_data()
	s.player_global_position = WorldData.player.global_position
	s.seed = WorldData.seed
	s.size = WorldData.size
	s.time = Time.get_datetime_string_from_system()
	s.buildings = WorldData.player.get_parent().get_node("BuildLayer").tile_map_data
	return s

func save(name:String) -> String:
	var save_path
	if name.is_empty():
		save_path = str(WorldData.world_name +".tres")
	else:
		save_path = str(name + ".tres")
	var data = create_save_data()
	print("Data: ", data.inventory)
	var error = ResourceSaver.save(data, SAVE_GAME_DIR + save_path)
	print(error)
	return save_path
	
static func load_game(name:String) -> Resource:
	if not ResourceLoader.exists(SAVE_GAME_DIR + name + ".tres"):
		return
	print(load(SAVE_GAME_DIR + name + ".tres"))
	return ResourceLoader.load(SAVE_GAME_DIR + name + ".tres")
	
static func load_all() -> Array:
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
