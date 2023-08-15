extends Node2D

var mj = [
	{
		"aaa": 1,
		"aac": 2,
		"aad": "3"
	},
	
	{
		"aaa": 11,
		"aac": 22,
		"aad": "4"
	},
	
	{
		"aaa": 77,
		"aac": 66,
		"aad": "foewrw"
	},
]

var json_string = JSON.stringify(mj)	


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var j = JSON.new()
	var d = j.data
	print(d)
	var e = j.parse(json_string)
	
	if typeof(d) == TYPE_ARRAY:
		print(d)

	
