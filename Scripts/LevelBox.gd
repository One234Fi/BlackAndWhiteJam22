extends PanelContainer

#Credit: https://kidscancode.org/godot_recipes/ui/level_select/

signal level_selected

var level_save = LevelSave

var locked = true setget set_locked
var level_num = 1 setget set_level

onready var label = $Label
onready var lock = $MarginContainer

var path = "res://Scenes/Stages/"

func set_locked(value):
	locked = value
	if not is_inside_tree():
		yield(self, "ready")
	lock.visible = value
	label.visible = not value

func set_level(value):
	level_num = value
	if not is_inside_tree():
		yield(self, "ready")
	label.text = str(level_num)

func _on_LevelBox_gui_input(event):
	if locked:
		#print("locked!")
		return
	if event is InputEventMouseButton and event.pressed:
		#print("Clicked level ", level_num)
		emit_signal("level_selected", level_num)
