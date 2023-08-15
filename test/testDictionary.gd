@tool
extends Node

@onready @export var dic = {
	1 : 1,
	a:c,
}

var a = "aaaa"
var c = 3



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
#	print(dic)
	for i in 3:		
		dic[dic.size()+1] = dic.size()
		
	for k in dic.keys():
		print(k," : ",dic[k])
	pass # Replace with function body.
