extends Node2D
class_name BBB


var bv = 4
var a:AAA
@onready var bbbb = 1

signal bsingal

#func _init(a:int):
#	print("b init")
#	bv=a
	# bv=20
	# pass
func _init():
	print("b init")
	pass



# Called when the node enters the scene tree for the first time.
func _ready():
	print("b ready")
	bbbb = 2
#	print("B的owner",owner)
	print("bbbb  " , bbbb)


	pass


#func _input(event):
#	if event.is_action_pressed("testKey"):
#		print("按下测试键")
#		get_tree().change_scene_to_file("res://test/A.tscn")
##		drawPos.position.x += 50
##		update()
#		pass

func bf1(a):
	print(a)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



# func bdo():
# 	print("bdo")

# 	emit_signal("bsingal")


# func _on_bsignal():
# 	print("b 对 b信号的响应")


func _on_B_ready():
	print("_on_B_ready")
	pass # Replace with function body.



func _on_B_tree_entered():
	print("_on_B_tree_entered")
	pass # Replace with function body.

func _enter_tree():
	print(self,"  _enter_tree")

func _on_B_tree_exited():
	print("_on_B_tree_exited")
	pass # Replace with function body.


func _exit_tree():
	print(self,"  _exit_tree")

func _on_B_tree_exiting():
	print("_on_B_tree_exiting")
	pass # Replace with function body.


func bOnSa():
	print("b on sa")
