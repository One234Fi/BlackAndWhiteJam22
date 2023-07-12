extends MarginContainer

var num_grids = 1
var current_grid = 1
var grid_width = 780

var locks = Array()

signal show_menu

onready var SceneManager = get_node("/root/Game/SceneManager")
onready var gridbox = $VBoxContainer/HBoxContainer/ClipControl/GridBox

func _ready():
	num_grids = gridbox.get_child_count()
	for grid in gridbox.get_children():
		for box in grid.get_children():
			box.connect("level_selected", SceneManager, "on_level_selected")
			box.connect("level_selected", self, "on_level_selected")

func _on_BackButton_pressed():
	if current_grid > 1:
		current_grid -= 1
		gridbox.rect_position.x += grid_width

func _on_NextButton_pressed():
	if current_grid < num_grids:
		current_grid += 1
		gridbox.rect_position.x -= grid_width

func _on_Menu_pressed():
	emit_signal("show_menu")
	hide()

func show():
	self.visible = true
	#print ("showing")
	update()

func hide():
	self.visible = false

func on_level_selected(_num):
	hide()

func update():
	for grid in gridbox.get_children():
		for box in grid.get_children():
			var num = box.get_position_in_parent() + 1 + 12 * grid.get_position_in_parent()
			box.level_num = num
			#print (str(box.locked) + " " + str(locks[num-1]))
			box.locked = false ##locks[num-1]
			
