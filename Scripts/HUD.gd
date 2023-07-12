extends CanvasLayer

func show():
	$TimerDisplay.visible = true
	$Label.visible = true
	$Stopwatch.visible = true
	

func hide():
	$TimerDisplay.visible = false
	$Label.visible = false
	$Stopwatch.visible = false
