extends AudioStreamPlayer


var musicList
var currentSong
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	musicList = dir_contents("res://Sounds/Music/")
	pick_song()

func pick_song():
	rng.randomize()
	var num = rng.randi_range(0, musicList.size()-1)
	if num < 0:
		num = 0
	currentSong = "res://Sounds/Music/" + musicList[num]
	set_stream(load(currentSong))
	play()

#from godot docs: https://docs.godotengine.org/en/stable/classes/class_directory.html
func dir_contents(path):
	var dir = Directory.new()
	var arr = Array()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				#print("Found directory: " + file_name)
				var _not_a_variable = 0
			else:
				#print("Found file: " + file_name)
				#if (not file_name.ends_with(".import")):
				var t = file_name.replace(".import", "")
				#print (t)
				arr.append(t)
			file_name = dir.get_next()
		#print (arr)
		return arr
	else:
		print("An error occurred when trying to access the path.")

func _on_Music_finished():
	pick_song()
