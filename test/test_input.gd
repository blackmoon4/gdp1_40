extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _input(event):
#	print(event)
	pass





func _unhandled_input(event):
	if event.is_action_pressed("click"):
		
		print(event)
	pass


func _unhandled_key_input(event):
#	print(event)
	pass
