#自动加载的脚本好像只能读到常量，错！！不能用类名获取，否则只能取到常量
#应该用设置里的自动加载名称来获取变量和方法


extends Node
#class_name AutoloadData

var testAutoloadVar1 = "testAutoloadVar1"
var a = "测试自动加载变量"

const TestAutoloadVar2Const = "TestAutoloadVar2Const"

#地图格大小
const TileMapSize = 64

const mapPanSpeed = 100

#是否显示所有塔的攻击范围,默认不显示
var isShowAllTowerRange = false

# 组名称 常量
const ENEMYGROUP := "enmeyGroup"	#敌人
const TOWERGROUP := "towerGroup"	#塔
const BUILDINGSLOTGROUP := "buildingSlotGroup"	#建造槽
const BULLETGROUP := "bulletGroup"	#子弹

#func _ready():
##	print("自动加载 :",self)	
#	pass


#func getMaingame():
#	var a = get_tree().root.find_child("TDmaingame",true,false)
#
#	if a != null:
#		return a
#	else:
#		print("没找到tdgame")
#		return null
#
#
#func getPlayer():
#	var p = get_tree().root.find_child("PlayerBase",true,false)
#	return p
