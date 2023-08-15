extends Node2D
class_name AAA

var av = 1


@export var aaa:PackedScene



@export var b: PackedScene
@export var c: PackedScene
# export var d: PackedScene
var bbbb: BBB


var b1 = false
# var c1:CCC
# var d1:DDD

@onready var aaaa = 1

var  ddd = {}

signal Sa(v1,v2)


func _init():
#	av = 2
	print("a init")
#	print(av2)
	pass


func _on_A_ready():
	print("_on_A_ready")
	pass # Replace with function body.

# Called when the node enters the scene tree for the first time.
func _ready():
	print("A ready")
#	print("aaaa " ,aaaa)
	aaaa =2
	print("aaaa " ,aaaa)
#	var v1 = 10
#	var v2 = "v2"
	
#	Sa.connect(onSa)
#	Sa.connect(onSa.bind(v1,v2))
	
#	Sa.emit()
	
#	print(b.resource_path)
#	var t = b.instantiate()
#	Sa.connect(Callable(t,"bOnSa"))
##	print(t.is_inside_tree())
#	add_child(t)
	
#	call_deferred("add_child",t)
#	print(t.is_inside_tree())
	pass

func onSa(v1,v2):
	print("on sa  ",v1," ",v2)


func _input(event):
#	print("_input")
#	print("a")
#
	if event.is_action_pressed("testKey"):
#		print("按下测试键")
##		get_tree().change_scene_to_file("res://test/B.tscn")
##		drawPos.position.x += 50
##		update()
		Sa.emit()
#		Sa.emit(1,"fdsfsf")
#		pass
	pass



func _unhandled_input(event):
#	print("_unhandled_input")
	pass


#func _unhandled_key_input(event):
#	print("_unhandled_key_input")
#	pass


func _process(delta):
	# print($Timer.time_left)
	# print($Timer.wait_time)
#	bar.value = $Timer.time_left / $Timer.wait_time
	pass





#
#func _draw():
#	draw_circle(drawPos.global_position,100,Color(.2,.2,.2,.5))
#	draw_circle(drawPos.position,100,Color(.6,.3,.4,.2))



#func _on_Node2D_draw():
#	draw_circle(Vector2.ZERO,100,Color.BLUE_VIOLET)
#	pass # Replace with function body.





func _on_A_tree_entered():
	print("_on_A_tree_entered")
	pass # Replace with function body.

func _enter_tree():
	print(self,"  _enter_tree")



func _on_A_tree_exiting():
	print("_on_A_tree_exiting")
	pass # Replace with function body.


func _exit_tree():
	print(self,"  _exit_tree")


func _on_A_tree_exited():
	print("_on_A_tree_exited")
	pass # Replace with function body.


func a():
	pass
