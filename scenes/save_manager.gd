extends Node
#class_name SaveManager
const SAVE_GAME_DIR = "user://save/"
var _saves: Array[SaveData] = []

func create_save_data() -> SaveData:
	var world: ProcWorld = get_tree().root.get_node("World")
	var cave_manager: CaveManager = get_tree().root.get_node("CaveManager")
	var s = SaveData.new()
	s.world_name = WorldData.world_name
	s.inventory = WorldData.player.inventory.get_data()
	s.player_global_position = WorldData.player.global_position if WorldData.player.get_parent() is World else cave_manager.get_cave_global_position()
	s.seed = WorldData.seed
	s.size = WorldData.size
	s.difficulty = WorldData.difficulty
	s.time = Time.get_datetime_string_from_system(true,true)
	world.save_loaded_chunks_objects()
	s.objects = world.object_tiles.duplicate(true)
	s.floors = world.floor_tiles.duplicate(true)
	s.quests = QuestHandler.quest_manager.get_data()
	s.caves = cave_manager.caves.duplicate(true)
	return s

func save(s_name:String = "autosave"):
	if s_name.is_empty(): 
		s_name = "autosave"
	var data = create_save_data()
	data.save_name = s_name
	var save_path: String = "%s_%s_%s.tres"%[data.world_name,data.save_name,data.time]
	var error = ResourceSaver.save(data, SAVE_GAME_DIR + save_path)
	if error:
		print_debug(error)
		return
	_saves.append(data)
	
func load_game(load_data: SaveData):
	WorldData.seed = load_data.seed
	WorldData.size = load_data.size
	WorldData.world_name = load_data.world_name
	WorldData.difficulty = load_data.difficulty
	WorldData.load = load_data
	QuestHandler.quest_manager.set_data(load_data.quests)
	if get_tree().root.has_node("CaveManager"):
		get_tree().root.get_node("CaveManager").queue_free()
	get_tree().change_scene_to_file("res://scenes/world/proc_world.tscn")

func load_game_by_name(s_name:String):
	var name_d: PackedStringArray = s_name.split(" - ") # 0 worldname, 1 savename, 2 time
	var load_data_arr = _saves.filter(func(element: SaveData): if element.world_name+element.save_name+element.time == "".join(name_d): return element)
	#var load_data_arr = ResourceLoader.load(SAVE_GAME_DIR + "_".join(name_d) + ".tres") - backup
	if load_data_arr.front() is SaveData:
		load_game(load_data_arr.front())

func load_last_save():
	var last_save = _saves.back()
	if last_save is SaveData:
		load_game(last_save)
	else:
		print("No saved games")

func remove_save(s_name: String) -> Error: # returns true if succesful
	var name_d: PackedStringArray = s_name.split(" - ") # 0 worldname, 1 savename, 2 time
	var err = DirAccess.remove_absolute(SAVE_GAME_DIR + "_".join(name_d) + ".tres")
	if err:
		return err
	var load_data = _saves.filter(func(element: SaveData): if element.world_name+element.save_name+element.time == "".join(name_d): return element)
	_saves.erase(load_data.front())
	return 0
	
func load_all() -> void:
	_saves.clear()
	if not DirAccess.dir_exists_absolute(SAVE_GAME_DIR):
		DirAccess.make_dir_absolute(SAVE_GAME_DIR)
	for file: String in DirAccess.get_files_at(SAVE_GAME_DIR):
		if not file.get_extension() == "tres":
			continue
		var save_data = ResourceLoader.load(SAVE_GAME_DIR+file)
		_saves.append(save_data)

func get_save_names():
	return _saves.map(func(element: SaveData): if element: return element.world_name+" - "+element.save_name+" - "+element.time)

func remove_world():
	for save: String in get_save_names():
		if save.begins_with(WorldData.world_name):
			remove_save(save)
