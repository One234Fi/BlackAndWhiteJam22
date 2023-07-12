extends Label


var time_elapsed = 0.0

func _process(delta):
	if visible:
		time_elapsed += delta
		text = display()

func display():
	var minutes = time_elapsed / 60
	var seconds = fmod(time_elapsed, 60)
	var milliseconds = fmod(time_elapsed, 1) * 100
	var time = "%02d:%02d:%02d" % [minutes, seconds, milliseconds]
	return time
