class_name SaveManager
extends Resource

const SAVE_GAME_PATH := "user://save"

export var version := 1

export var level_list: Resource = LevelList.new()

func write_savegame() -> void:
# warning-ignore:return_value_discarded
	ResourceSaver.save(get_save_path(), self)

static func save_exists() -> bool:
	return ResourceLoader.exists(get_save_path())

static func load_savegame() -> Resource:
	var save_path = get_save_path()
	if ResourceLoader.has_cached(save_path):
		return ResourceLoader.load(save_path, "", true)
	
	var file := File.new()
	if file.open(save_path, File.READ) != OK:
		printerr("couldnt read file " + save_path)
		return null
	
	var data := file.get_as_text()
	file.close()
	
	var tmp_file_path := make_random_path()
	while ResourceLoader.has_cached(tmp_file_path):
		tmp_file_path = make_random_path()
	
	if file.open(tmp_file_path, File.WRITE) != OK:
		printerr("Couldn't write file " + tmp_file_path)
		return null
	
	file.store_string(data)
	file.close()
	
	var save = ResourceLoader.load(tmp_file_path, "", true)
	save.take_over_path(save_path)
	
	var directory := Directory.new()
# warning-ignore:return_value_discarded
	directory.remove(tmp_file_path)
	return save

static func make_random_path() -> String:
	return "user://temp_file_" + str(randi()) + ".tres"

static func get_save_path() -> String:
	var extension := ".tres" if OS.is_debug_build() else ".res"
	return SAVE_GAME_PATH + extension
