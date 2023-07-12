extends TileMap

signal damage
signal level_cleared
signal reload

export var next_level = ''
var death_count = 0
onready var SceneManager = get_node("/root/Game/SceneManager")

func _ready():
	#connect level-related signals to the scene manager
# warning-ignore:return_value_discarded
	self.connect("level_cleared", SceneManager, "on_level_cleared")
# warning-ignore:return_value_discarded
	self.connect("reload", SceneManager, "on_reload")

func _process(_delta):
	if Input.is_action_pressed("restart"):
		emit_signal("reload")
		#queue_free()

func _on_Player_collided(collision):
	if collision.collider is TileMap:
		if collision.collider.is_in_group("hazard"):
			#print('hazard hit')
			emit_signal('damage')
		else:
			var tile_pos = collision.collider.world_to_map(find_node("Player").position)
			tile_pos -= collision.normal
			var tile = collision.collider.get_cellv(tile_pos)
			if tile == 6 && !collision.collider.is_in_group("hazard"):
				emit_signal("level_cleared")
				#queue_free()
			

func reload():
	emit_signal("reload")
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()

func _on_Player_spawn_block(block_pos):
	var spawn_pos = world_to_map(block_pos)
	set_cellv(spawn_pos, 5)
	update_dirty_quadrants()
	death_count += 1
	$DeathCount.text = "Death Count: " + str(death_count)
