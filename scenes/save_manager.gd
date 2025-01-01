extends Node
#class_name SaveManager
const SAVE_GAME_DIR = "user://save/"
var _saves: Array[SaveData] = []

func create_save_data() -> SaveData:
	var world: ProcWorld = get_tree().root.get_node("World")
	var s = SaveData.new()
	s.world_name = WorldData.world_name
	s.inventory = WorldData.player.inventory.get_data()
	s.player_global_position = WorldData.player.global_position
	s.seed = WorldData.seed
	s.size = WorldData.size
	s.time = Time.get_datetime_string_from_system(true,true)
	world.save_loaded_chunks_objects()
	s.objects = world.object_tiles.duplicate(true)
	s.floors = world.floor_tiles.duplicate(true)
	s.quests = QuestHandler.quest_manager.get_data()
	return s

func save(name:String = "autosave"):
	if name.is_empty(): name = "autosave"
	var data = create_save_data()
	data.save_name = name
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
	WorldData.load = load_data
	QuestHandler.quest_manager.set_data(load_data.quests)
	#WorldData.player.get_tree().root.get_node("CaveManager").queue_free()
	get_tree().change_scene_to_file("res://scenes/world/proc_world.tscn")

func load_game_by_name(name:String):
	var name_d: PackedStringArray = name.split(" - ") # 0 worldname, 1 savename, 2 time
	if not ResourceLoader.exists(SAVE_GAME_DIR + "_".join(name_d) + ".tres"):
		return false
	var load_data_arr = _saves.filter(func(element: SaveData): if element.world_name+element.save_name+element.time == "".join(name_d): return element)
	#var load_data_arr = ResourceLoader.load(SAVE_GAME_DIR + "_".join(name_d) + ".tres") - backup
	if load_data_arr.front() is SaveData:
		load_game(load_data_arr.front())

func load_last_save():
	var last_save = _saves.back()
	if last_save is SaveData:
		load_game(last_save)

func remove_save(name: String) -> Error: # returns true if succesful
	var name_d: PackedStringArray = name.split(" - ") # 0 worldname, 1 savename, 2 time
	var err = DirAccess.remove_absolute(SAVE_GAME_DIR + "_".join(name_d) + ".tres")
	return err
	var load_data = _saves.filter(func(element: SaveData): if element.world_name+element.save_name+element.time == "".join(name_d): return element)
	_saves.erase(load_data.front())
	
func load_all() -> void:
	_saves.clear()
	if not DirAccess.dir_exists_absolute(SAVE_GAME_DIR):
		DirAccess.make_dir_absolute(SAVE_GAME_DIR)
	for file in DirAccess.get_files_at(SAVE_GAME_DIR):
		if not file.get_extension() == "tres":
			continue
		var save_data = ResourceLoader.load(SAVE_GAME_DIR+file)
		_saves.append(save_data)

func get_save_names():
	return _saves.map(func(element: SaveData): return element.world_name+" - "+element.save_name+" - "+element.time)
