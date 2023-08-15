extends Node


@export var a=[]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in a:
		
#		print(i.var1_name1)
		print(i.get("var1_name"))
	pass # Replace with function body.
