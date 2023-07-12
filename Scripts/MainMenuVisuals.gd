extends Node2D

func _ready():
# warning-ignore:return_value_discarded
	$UserInput.connect("start_game", self, "on_start_game")

func on_start_game():
	#print("starting game")
	self.hide()
	
