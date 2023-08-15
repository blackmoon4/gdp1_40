@tool
extends Node2D

@export var a =1 :
	get:
#		print(a)
		return a 
	set(mod_value):
		a=mod_value +1 
		b=a
		print(a)
@export var b: int=0 :
	get:
		return b 
	set(mod_value):
		b=a

func _ready():
	print("tool")
	print("a ",a)
	print("b ",b)

	if Engine.is_editor_hint():
		print("run in edit")
	if not Engine.is_editor_hint():
		print("run in rungame")
	
	print("run in all")



# func _process(delta):
# 	if Engine.editor_hint:
# 		print("tool")


func seta(v):
	a = v
	setb(1)
	# print(a)
	# return a
	


func setb(v):
	b = a+1

	# print(b)
	# return b


func getb():
	return b
