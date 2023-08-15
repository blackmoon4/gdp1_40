# extends CharacterBody2D
# 管理玩家的数据 逻辑
extends Node2D
class_name PlayerBase

# export (int) var movespeed = 100
@export var towerPS: PackedScene

# var target = Vector2()
# var velocity = Vector2()

# func _init():
# 	pass

#var maingame : TDMaingame
@onready var maingame : TDMaingame = TD_global.getMaingame()

var playername := "鉴定为机"
var BaseHP:=10	#基地生命值



# Called when the node enters the scene tree for the first time.
func _ready():
	# print("player ready")
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta):
# 	pass


# func _physics_process(delta):
# 	velocity = position.direction_to(target) * movespeed * delta
	
# 	# 朝向目标位置
# 	# look_at(target)

# 	if position.distance_to(target) > 5 :   #防止距离过小抖动
		
# 		# 滑动移动
#		set_velocity(velocity)
#		move_and_slide()
# 		# velocity = velocity
		
# 		# 遇到障碍停止
# 		velocity = move_and_collide(velocity)




#放到场景里
func buildTower():
	# print("盖塔喽！")
	var t = towerPS.instantiate()
	var maplogiclayer = maingame.mapref.LogicLayer
	var p = get_global_mouse_position()
	p = maplogiclayer.to_local(p)
	var id = maplogiclayer.local_to_map(p)
	p = maplogiclayer.map_to_local(id)
	p = maplogiclayer.to_global(p)
	p += Vector2(32,32)
	t.position = p
	t.maingame = maingame

	# t.add_to_group("towerssssss")	
	maingame.mapref.YsortParent.add_child(t)
