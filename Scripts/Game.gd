extends Node2D

var _save: SaveManager

onready var level_menu = $LevelMenu
onready var main_menu = $MainMenu
onready var main_menu_ui = $MainMenu/UserInput
onready var input = $MainMenu/UserInput
onready var SceneManager = $SceneManager

signal start_game

func _ready():
	_create_or_load_save()
	#_create_save()
	
	input.connect("show_level_select", self, "on_show_level_select")
	level_menu.connect("show_menu", self, "on_show_menu")
	main_menu_ui.connect("start_game", self, "on_start_game")
	

func on_show_level_select():
	level_menu.show()
	main_menu.hide()
	input.hide()
	SceneManager.get_child(0).hide()

func on_show_menu():
	level_menu.hide()
	main_menu.show()
	input.show()
	SceneManager.get_child(0).hide()

func on_start_game():
	var child = SceneManager.get_child(0)
# warning-ignore:return_value_discarded
	self.connect("start_game", child, "start_level")
	emit_signal("start_game")

func on_level_cleared(level_name):
	var level_index = int(level_name.replace("level_", ""))
	if level_index < 12:
		level_menu.locks[level_index-1] = false
	else:
		print ("index is greater than 11")

func on_quit():
	save_game()
	print("saving...")
	yield(get_tree().create_timer(0.5), "timeout")
	get_tree().quit()

func save_game():
	var count = level_menu.locks.size()
	#print (count)
	for i in range(0, count):
		var l_name = "level_" + str(i+1)
		_save.level_list.set_level(l_name, level_menu.locks[i], 0.0, 0)
	
	print(_save.level_list.get_lock_array())
	_save.write_savegame()

#for debug purposes
func _create_save() -> void:
	_save = SaveManager.new()
	_save.level_list.set_level("level_1", false, 0.0, 0)
		
	for i in range (2, 13):
		var temp = "level_" + str(i)
		#print ("setting level " + str(i))
		
		_save.level_list.set_level(temp, true, 0.0, 0)
	_save.write_savegame()
	var lock_array = _save.level_list.get_lock_array()
	level_menu.locks = lock_array

func _create_or_load_save() -> void:
	if SaveManager.save_exists():
		_save = SaveManager.load_savegame()
		#print ("found a file!")
	else:
		#print("did not find a file...")
		_save = SaveManager.new()
		
		_save.level_list.set_level("level_1", false, 0.0, 0)
		
		for i in range (2, 13):
			var temp = "level_" + str(i)
			#print ("setting level " + str(i))
			
			_save.level_list.set_level(temp, true, 0.0, 0)
		_save.write_savegame()
	
	#after creating or loading, send the data to the nodes that need it (the levelboxes I think)
	var lock_array = _save.level_list.get_lock_array()
	#print (lock_array)
	level_menu.locks = lock_array
