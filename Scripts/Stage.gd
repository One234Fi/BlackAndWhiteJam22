extends Node2D

var _save : SaveManager
var next_level_name

signal level_cleared

onready var player = $Level/Player
onready var hud = $Level/Player/HUD
onready var Game = get_node("/root/Game")

func _ready():
	player.hide()
	hud.hide()
	self.hide()
	
	var num = int(name.replace("Stage", "")) + 1
	next_level_name = "level_" + str(num)
	#print(level_name)
	
	
# warning-ignore:return_value_discarded
	$Level.connect("level_cleared", self, "on_level_cleared")
# warning-ignore:return_value_discarded
	self.connect("level_cleared", Game, "on_level_cleared")
	

#get the current level, set it to unlocked
#check for a new highscore and overwrite if so
func on_level_cleared():
	player.hide()
	hud.hide()
	self.hide()
	emit_signal("level_cleared", next_level_name)

func start_level():
	player.show()
	hud.show()
	self.show()
