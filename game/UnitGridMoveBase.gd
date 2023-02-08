extends Node2D
class_name UnitGridMoveBase

@export var _unitData : UnitData
#@export var unitData : Resource


#var d : UnitData = unitData
var map:GameTileMap    #游戏地图
var mappos:Vector2i   #玩家角色当前位置坐标
var moveDirection:Vector2i   #角色移动方向

#角色移动力，每次可移动的最大格数，最远距离
var moveRange:int = randi_range(3,5)

#行动点
var actionPoint:int = 1

var unitName := "一个小兵"

#行动目标单位
var targetUnit : UnitGridMoveBase

#当进入一个格子时,tileid是进入的格子
signal tile_entered(tileid)

#当该单位被选中
signal selected(unit)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#	unitName += str(randi_range(0,10))
#	setPlayerPosition(Vector2i(0,0))	
	
	tile_entered.connect(_on_tile_entered)
#	selected.connect(_on_selected)
#	map.select_unit.connect(_on_selected)



func _unhandled_input(_event: InputEvent) -> void:
	pass


#把玩家设置到地图格子位置
func setPlayerPosition(map_pos:Vector2i):
	var p = map.map_to_local(map_pos)
	position = p


#朝一个方向移动
#func MoveToDirection(direction:Vector2i) -> void:
#	var newpos = mappos + direction
#	setPlayerPosition(newpos)
#	mappos = newpos
#	tile_entered.emit(newpos)


##移动到指定格子，使用astargrid导航
#func MoveToPos(targetpos:Vector2i)->void:
#	pass


#func MoveFollowPath():
#	map.unitpath


func _on_tile_entered(tileid) -> void:
	print(tileid)
	pass


func _on_selected()->void:
	pass

