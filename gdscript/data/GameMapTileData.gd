#地图格子里的数据

extends RefCounted
class_name GameMapTileData

#格子上的单位，可自动寻路移动
var Unit : UnitGridMoveBase

#格子的ID
var ID : int

##是否能通过
#var CanPass : bool


func _init() -> void:
	pass
