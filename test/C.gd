extends Node2D
class_name CCC

var cv
var b : BBB


func _init():
	print("c init")



# Called when the node enters the scene tree for the first time.
func _ready():
	print("c ready")
#	print("c的owner",owner)
	

	# b.connect("bsingal",Callable(self,"_on_bsignal"))
	pass # Replace with function body.



# func _on_bsignal():
# 	print("c 对于 b 信号的 响应")
