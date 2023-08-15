extends Node2D
@onready var node_2d = $Node2D

var a = true

func _ready():
	pass

func _input(event):
	if event.is_action_pressed("testKey"):
		queue_free()
#		node_2d.free()



func _process(delta):
	if a:
		print(node_2d.position)



func _on_Node2D_child_exiting_tree(node):
#	print("_on_Node2D_child_exiting_tree")
#	a = false
	pass # Replace with function body.



func _on_Node2D_tree_exiting():
#	print("_on_Node2D_tree_exiting")
#	a = false
	pass # Replace with function body.
	
	

func _on_Node2D_tree_exited():
#	print("_on_Node2D_tree_exited")
#	a = false
	pass # Replace with function body.


func _on_testFreeDelete_tree_exiting():
	print("_on_testFreeDelete_tree_exiting")
	a = false
	pass # Replace with function body.
