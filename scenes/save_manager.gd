extends Resource
class_name SaveManager
const SAVE_GAME_DIR = "user://save/"
static var saves = []

static func create_save_data() -> SaveData:
	var world: ProcWorld = WorldData.player.get_tree().root.get_node("World")
	var cave_manager: CaveManager = WorldData.player.get_tree().root.get_node("CaveManager")
	var s = SaveData.new()
	s.world_name = WorldData.world_name
	s.inventory = WorldData.player.inventory.get_data()
	s.player_global_position = WorldData.player.global_position if WorldData.player.get_parent() is World else cave_manager.get_cave_global_position()
	s.seed = WorldData.seed
	s.size = WorldData.size
	s.time = Time.get_datetime_string_from_system()
	world.save_loaded_chunks_objects()
	s.objects = world.object_tiles.duplicate(true)
	s.floors = world.floor_tiles.duplicate(true)
	s.quests = QuestHandler.quest_manager.get_data()
	s.caves = cave_manager.caves.duplicate(true)
	return s

static func save(name:String) -> String:
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
	
static func load_game(name:String) -> bool:
	if not ResourceLoader.exists(SAVE_GAME_DIR + name + ".tres"):
		return false
	var load_data = ResourceLoader.load(SAVE_GAME_DIR + name + ".tres")
	if load_data is SaveData:
		WorldData.seed = load_data.seed
		WorldData.size = load_data.size
		WorldData.world_name = load_data.world_name
		WorldData.load = load_data
		QuestHandler.quest_manager.set_data(load_data.quests)
		#get_tree().root.get_node("CaveManager").queue_free()
		#get_tree().change_scene_to_file("res://scenes/start.tscn")
		return true
	printerr("load_data is not SaveData")
	return false
	
static func remove_save(name: String) -> Error:
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
