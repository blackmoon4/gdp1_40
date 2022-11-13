extends Node
class_name TDMaingame

@export var playerPS: PackedScene
# export var playerController: PackedScene
#export var gameuiPS: PackedScene
@export var gamedata: Resource

# var levelPath: PackedScene

var playerRef
var gameUIref
#var UIref = preload("res://UI/MainMenu.tscn").instantiate()

#var mapref
#onready var game_map_layer = $"%gameMapLayer"


## 组名称 常量,放到autoload的里面去了
#const ENEMYGROUP := "enmeyGroup"	#敌人
#const TOWERGROUP := "towerGroup"	#塔
#const BUILDINGSLOTGROUP := "buildingSlotGroup"	#建造槽
#const BULLETGROUP := "bulletGroup"	#子弹


# Called when the node enters the scene tree for the first time.
func _ready():
#	print("maingame ready")
#	print(TD_global.a)
#	print(TD_global.TestAutoloadVar2Const)

	playerRef = playerPS.instantiate()
	add_child(playerRef)

#	UIref = load("res://UI/MainMenu.tscn").instantiate()
#	$CanvasLayer_ui.add_child(UIref)
#

#
#	gameUIref.setupUI(mapref)




# func spawnTower(pos:Vector2):
# 	var t = playerRef.towerPS.instantiate()
# 	t.position = pos
# 	towersParent.add_child(t)



func newgame():
	print("新游戏")
	print(TD_global.a)
#	mapref = load("res://level/level_1.tscn").instantiate()
#	mapref.position = Vector2(100,100)
#	game_map_layer.add_child(mapref)
	get_tree().change_scene_to_file("res://level/level_1.tscn")
