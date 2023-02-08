extends Area2D
class_name PlayerGridMove

var map:GameMap    #游戏地图
var pos:Vector2i   #玩家角色当前位置坐标
var moveDirection:Vector2i   #角色移动方向

@export var unitData : UnitData

#当进入一个格子时,tileid是进入的格子
signal tile_entered(tileid)



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setPlayerPosition(Vector2i(0,0))
	tile_entered.connect(_on_tile_entered)
	pass # Replace with function body.


## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta: float) -> void:
#	pass



func _unhandled_key_input(event: InputEvent) -> void:
#func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_left"):
		moveDirection = Vector2i.LEFT
	if event.is_action_pressed("ui_right"):
#	if event.is_action_pressed("ui_right"):
		moveDirection = Vector2i.RIGHT
	if event.is_action_pressed("ui_up"):
		moveDirection = Vector2i.UP
	if event.is_action_pressed("ui_down"):
		moveDirection = Vector2i.DOWN
		
	MoveToDirection(moveDirection)
	
	moveDirection = Vector2i.ZERO
	



#把玩家设置到地图格子位置
func setPlayerPosition(map_pos:Vector2i):
	var p = map.map_to_local(map_pos)
	position = p


#朝一个方向移动
func MoveToDirection(direction:Vector2i) -> void:
	var newpos = pos + direction
	setPlayerPosition(newpos)
	pos = newpos
	tile_entered.emit(newpos)


func _on_tile_entered(tileid) -> void:
	print(tileid)
	pass
