extends Node

var stages
var stage_path = "res://Scenes/Stages/"
var scene_path = "res://Scenes/"
var stage_num = 0

var current_scene 

signal start_lvl

#recieves a signal from the current level, reloads, and resets current_scene
func on_reload():
	var temp = stage_path + get_child(0).name + ".tscn"
	on_change_scene(temp)

func on_level_selected(num):
	var new_level = "res://Scenes/Stages/Stage" + str(num) + ".tscn"
	on_change_scene(new_level)

# recieves a signal from the current level, grabs its name, and passes it to start_next()
func on_level_cleared():
	var curr_scene = get_child(0).name
	
	start_next(curr_scene)

#determines what the next stage is and then calls the function to load it
func start_next(name):
	#print(name + "NAME")
	var next_scene
	if (name == "MainMenu"):
		next_scene = stage_path + "Stage1.tscn"
		on_change_scene(next_scene)
	elif name == "Final Scene":
		#next_scene = scene_path + "MainMenu.tscn"
		next_scene = stage_path + "Stage1.tscn"
		on_change_scene(next_scene)
		get_child(0).hide()
	else:
		var index = int(name.replace("Stage", ""))
		next_scene = name.replace(str(index), "")
		index += 1
		next_scene = next_scene + str(index)
		#print(next_scene + " NEW SCENE CHECK")
		on_change_scene(stage_path + next_scene + ".tscn")

#deferres changing the scene until its safer to do so
func on_change_scene(new_scene):
	#print (str(new_scene) + " HI THIS WORKS")
	call_deferred("deferred_change_scene", new_scene)

#changes the scene
func deferred_change_scene(new_scene):
	var currStage = get_child(0)
	remove_child(currStage)
	var s = ResourceLoader.load(new_scene).instance()
	add_child(s)
	
# warning-ignore:return_value_discarded
	self.connect("start_lvl", get_child(0), "start_level")
	emit_signal("start_lvl")
	currStage.call_deferred("queue_free")
