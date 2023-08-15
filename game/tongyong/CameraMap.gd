#可以拖动在地图上移动

extends Camera2D
class_name CameraMap

#是否按下
var isclickdown := false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass



func _input(event: InputEvent) -> void:
#	if event.is_action_pressed("click"):
	if event.is_action_pressed("click"):
		isclickdown = true
	
	if event.is_action_released("click"):
		isclickdown = false

		
	if event is InputEventMouseMotion and isclickdown:
		self.position -= event.relative

#get_viewport().get_mouse_position()
