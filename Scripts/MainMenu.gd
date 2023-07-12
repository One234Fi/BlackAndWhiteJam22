extends CanvasLayer

signal show_level_select
signal start_game
signal quit_game

onready var SceneManager = get_node("/root/Game/SceneManager")
onready var Game = get_node("/root/Game")

# Called when the node enters the scene tree for the first time.
func _ready():
# warning-ignore:return_value_discarded
	self.connect("quit_game", Game, "on_quit")

func hide():
	$Play.visible = false
	$Levels.visible = false
	$Quit.visible = false

func show():
	$Play.visible = true
	$Levels.visible = true
	$Quit.visible = true

func _on_Play_pressed():
	emit_signal("start_game")
	hide()

func _on_Quit_pressed():
	emit_signal("quit_game")

func _on_Levels_pressed():
	emit_signal("show_level_select")
	hide()
	
