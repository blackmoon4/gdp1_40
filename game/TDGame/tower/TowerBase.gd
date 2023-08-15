extends Node2D
class_name TowerBase


# 攻击距离，1单位是100像素
@export var atkRange :float = 3
#	get:
#		return atkRange # TODOConverter40 Non existent get function
#	set(mod_value):
#		mod_value  # TODOConverter40 Copy here content of setatkRange

#塔是否能攻击
@export var canAttack := true

#是否显示攻击范围
#@export var ShowRange := false
@export var bullet: PackedScene
# export var rangecolor: Color
# export var collishape: NodePath
# onready var rangeshapeN := get_node(collishape) as CollisionShape2D


#运行时
#var maingame : TDMaingame

var targetEnemyArray = []    #射程内的敌人列表
var haveTargetEnemy = false    #当前是否有敌人，初始为空
var targetEnemy : EnemyBase = null    #当前的目标敌人
#var targetPos    #当前敌人的位置



@onready var timer : Timer = $Timer
@onready var atkPos = %Position2D_atk
@onready var paoguan = %paoguan



# 信号
# 开火,target是目标的位置
signal atk(tower,bullet,target)


#func _init():
#	pass


#	Called when the node enters the scene tree for the first time.
func _ready():
#	print(name)
	$AtkRange/CollisionShape2D.shape.radius = atkRange * TD_global.TileMapSize
	add_to_group(TD_global.TOWERGROUP)
	# print(get_groups())
	# print(get_tree().get_nodes_in_group("towerssssss"))
	# print(atkRange)
#	$AtkRange.visible = canAttack
#	if canAttack == true:
#	connect("atk",Callable(maingame.mapref,"OnTowerAtk"))

	# $AtkRange/CollisionShape2D.shape.radius = atkRange

	# timer.start(0)
	# timer.paused = true
#	pass




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	print(targetEnemy)
#	if targetEnemy!=null and targetEnemy.is_queued_for_deletion():
#		print(1)
#
	if targetEnemy:
		paoguan.look_at(targetEnemy.global_position)

#	测试用
#	paoguan.look_at(to_global(get_local_mouse_position()))





#func _physics_process(_delta):
#	if targetEnemy != null:
#		paoguan.look_at(targetEnemy.position)



# 攻击计时器
func _on_Timer_timeout():
	# print(" %s 开火了 , 目标是 %s" % [self,targetEnemyArray[0]])
	# 确定目标，如果是有目标的话
#	targetEnemy = getAtkTarget()
#	print("确定目标敌人",targetEnemy)
	if targetEnemy:
		TowerAttack(targetEnemy)
#	print("攻击")



#func setatkRange(value:float):
#	atkRange = value * 64.0



func _on_AtkRange_area_entered(area:Area2D):
#	print("进入射程")
#	print("塔入：",area.owner)
#	print("塔入layer：",$AtkRange.collision_layer)

	# 检查碰撞的所有者类型是否是EnemyBase
	if area.owner is EnemyBase:
		# 把进入范围的敌人存入目标列表
		targetEnemyArray.append(area.owner)
#		print(targetEnemyArray)
		
#		if timer.is
		
		if targetEnemy == null:
#			print("开始攻击")
			targetEnemy = getAtkTarget()
			TowerAttack(targetEnemy)
			pass

		# 如果敌人列表不为空，则开始攻击
#		if not targetEnemyArray.is_empty():
#			TowerAttack()
	#		targetEnemy.connect("die",Callable(self,"onTargetDestroy"))
	#		$Timer.paused=false



func _on_AtkRange_area_exited(area:Area2D):
#	print("塔出：",area.owner)
#	print("塔出layer：",$AtkRange.collision_layer)
	# var i = targetEnemyArray.find(area.owner)
	# if i != -1:
	# 	targetEnemyArray.remove_at(i)

	# 检查碰撞的所有者类型是否是EnemyBase
	if area.owner is EnemyBase:
		# 把这个移除敌人列表
		targetEnemyArray.erase(area.owner)
#		重新找新目标
		targetEnemy = getAtkTarget()
#		haveTargetEnemy = false
#		print(targetEnemyArray)

	# 如果敌人列表为空，则停止炮塔循环 计时
#	if targetEnemyArray.is_empty():
#		$Timer.stop()




# 按加入列表的先后次序挨个设为目标
#func getAtkTarget() -> EnemyBase:
#	if not targetEnemyArray.is_empty():
#		# 找最早进入范围的
#		targetEnemy = targetEnemyArray[0]
#		if targetEnemy != null:
##			if not targetEnemy.is_connected("die",Callable(self,"onTargetDestroy")):
##				targetEnemy.connect("die",Callable(self,"onTargetDestroy"))
##			print("当前目标： ",targetEnemy)
#			if not targetEnemy.is_connected("tree_exiting",Callable(self,"onEnmeyDie")):
#				targetEnemy.connect("tree_exiting",Callable(self,"onEnmeyDie"))
##			haveTargetEnemy = true
#			return targetEnemy
#		else:
#			targetEnemy = null
##			print("当前目标： ",targetEnemy)
#			return null
#	else:
#		# is_instance_valid(
#		# targetEnemy = null
##		print("当前目标列表为空")
#		return null
	



func getAtkTarget() -> EnemyBase:
	if targetEnemyArray.is_empty():
		return null
	
#	按进入列表的先后次序
	targetEnemy = targetEnemyArray[0]	
	if not targetEnemy.is_connected("tree_exiting",Callable(self,"onEnmeyDie")):
		targetEnemy.connect("tree_exiting",Callable(self,"onEnmeyDie"))
	return targetEnemy




func onTargetDestroy(enemy):
	targetEnemyArray.erase(enemy)
	# targetEnemy = getAtkTarget()
	# if newtarget != null:
	# 	newtarget.connect("die",Callable(self,"targetDestroy"))




# 炮塔攻击,同时也是开启炮塔攻击循环
#可优化
func TowerAttack(target):
#	targetEnemy = getAtkTarget()
#	print("确定目标敌人",targetEnemy)

#	如果敌人不为空则发射子弹，如果敌人为空，则停止攻击
#	if targetEnemy != null :
		# if not targetEnemy.is_connected("die",Callable(self,"onTargetDestroy")):
		# 	targetEnemy.connect("die",Callable(self,"onTargetDestroy"))

	# 发射子弹
#		print("开始攻击,攻击循环计时")
	var b = bullet.instantiate() as BulletBase
#	add_child(b)
#	call_deferred("add_child",b)
	b.position = atkPos.global_position
	var targetPos = target.global_position
	b.look_at(targetPos)
	b.movevector = b.position.direction_to(targetPos)
	emit_signal("atk",self,b,target)
#	add_child(b)
	call_deferred("add_child",b)

	# 开启塔的循环计时
	if $Timer.is_stopped():
		$Timer.start()

#	else:
##		print("没有找到合适的敌人可攻击,停止攻击循环")
#		$Timer.stop()



func testgroup(i):
	print(name," -- testgroup - -",i)


func _draw():
#	print("_draw")
	if TD_global.isShowAllTowerRange:
		draw_circle(Vector2.ZERO,atkRange * TD_global.TileMapSize,Color(1,0,0,.2))


func setShowRange(isshow:bool = false) -> void:
	TD_global.isShowAllTowerRange = isshow
	queue_redraw()


func onEnmeyDie():
	pass
