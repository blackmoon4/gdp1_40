extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("start")
	await get_tree().create_timer(1).timeout
	print("end")
	queue_free()
#	await get_tree().create_timer(2).timeout
#	print("dsadsa")
#	print("dsadsa")
#	print("dsadsa")
#	for i in range(10):
#		print(i)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func f():
	print("start")
	await get_tree().create_timer(1).timeout
	print("end")
