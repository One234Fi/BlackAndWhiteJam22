extends CanvasLayer

signal show_menu
signal show_level_select
signal quit_game

onready var SceneManager = get_node("/root/Game/SceneManager")
onready var Game = get_node("/root/Game")

func _ready():
	$Play.hide()
	$Menu.hide()
	$Levels.hide()
	$Quit.hide()
	
# warning-ignore:return_value_discarded
	self.connect("show_menu", Game, "on_show_menu")
# warning-ignore:return_value_discarded
	self.connect("show_level_select", Game, "on_show_level_select")
# warning-ignore:return_value_discarded
	self.connect("quit_game", Game, "on_quit")

func _process(_delta):
	if Input.is_action_pressed("pause"):
		get_tree().paused = true
		$Play.show()
		$Menu.show()
		$Levels.show()
		$Quit.show()

func _on_Play_pressed():
	$Play.hide()
	$Menu.hide()
	$Levels.hide()
	$Quit.hide()
	get_tree().paused = false

func _on_Quit_pressed():
	emit_signal("quit_game")

func _on_Menu_pressed():
	$Play.hide()
	$Menu.hide()
	$Levels.hide()
	$Quit.hide()
	get_tree().paused = false
	emit_signal("show_menu")

func _on_Levels_pressed():
	$Play.hide()
	$Menu.hide()
	$Levels.hide()
	$Quit.hide()
	get_tree().paused = false
	emit_signal("show_level_select")
