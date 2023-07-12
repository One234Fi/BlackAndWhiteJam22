class_name LevelList
extends Resource

export var levels := {}

#add a level to the levels dictionary, unique id is level_name
func set_level(level_name: String, locked: bool, time: float, death_count: int) -> void:
	#if level_name in levels:
		#print ("overwriting " + level_name)
	#else:
		#print ("adding " + level_name)
	
	levels[level_name] = [locked, time, death_count]

func get_locked(level_name: String) -> bool:
	return levels[level_name][0]

func get_time(level_name: String) -> float:
	return levels[level_name][1]

func get_death_count(level_name: String) -> int:
	return levels[level_name][2]

func is_a_record(level_name: String, new_time: float, new_death_count: int) -> bool:
	if get_time(level_name) == 0.0:
		return true
	if new_time < get_time(level_name):
		return true
	elif new_time == get_time(level_name) && new_death_count < get_death_count(level_name):
		return true
	 
	return false

func get_lock_array() -> Array:
	var array = Array()
	var key_list = levels.keys()
	key_list.sort_custom(CustomSort, "sort_keys")
	#print (key_list)
	for i in key_list:
		array.append(levels.get(i)[0])
	return array

class CustomSort:
	static func sort_keys(a, b):
		if a.length() == b.length():
			var a_num = int(a.replace("level_", ""))
			var b_num = int(b.replace("level_", ""))
			if a_num < b_num:
				return true
			else:
				return false
		else:
			if a.length() < b.length():
				return true
			return false
