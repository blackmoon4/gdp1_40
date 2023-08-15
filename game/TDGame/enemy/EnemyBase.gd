extends Node2D
class_name EnemyBase


#DATA
#@export var data : EnemyData


# 移动速度
@export var movespeedMin = 50
@export var movespeedMax = 100
var movespeed : float
#var movespeed : float = randf_range(movespeedMin,movespeedMax)
#生成的时间间隔
var spawnTime : float = 1.0
#剩余可生成的数量
#static var spawnCountLeft : int = 0

# 怪物名字
var enmeyName : String = "怪物名字"

# 生命值
var healthMax:int = 100
var health:int = healthMax

var levelBase
# 对基地造成的伤害
var damageBase = 1

# 引用  ===================== 
#onready var maingameRef : TDMaingame = TD_global.getMaingame()


# 信号  =====================
# 到达终点
signal reach()
# 死亡
signal die


# var remoter : RemoteTransform2D
var pathfollow : PathFollow2D
# onready var pathfollow = $".." as PathFollow2D

# onready var levelRef := get_node("..")
# var levelRef : TDMapBase
# var levelRef
# onready var levelRef :TDMapBase= $".."



func _ready():
#	$Label.text = data.Name
	movespeed = randf_range(movespeedMin,movespeedMax)
	
	reach.connect(reachTarget)
	
	updateHPbar()
#	if not is_connected("die",Callable(maingameRef.mapref,"destroyUnit")):
#		connect("die",Callable(maingameRef.mapref,"destroyUnit"))
	add_to_group(TD_global.ENEMYGROUP)
	var a=get_tree().get_nodes_in_group(TD_global.ENEMYGROUP)
#	print(a.size()," 个敌人")



#func _process(_delta):
#	move(_delta)
#
#	if pathfollow.progress_ratio >= 1:
#		reachTarget()


func _physics_process(delta):
#	沿路径移动
	if pathfollow:
		pathfollow.progress += movespeed * delta
#		监测是否到达终点
		if pathfollow.progress_ratio >= 1:
#			reachTarget()
			reach.emit(self)



func move(delta):
	# position.x -= movespeed * delta
	if pathfollow:
		pathfollow.progress += movespeed * delta
	#	pathfollow.progress_ratio += movespeed * delta



# 到达目的地,扣除基地生命
func reachTarget(e):
#	emit_signal("reach",self)
	# print(name,"到了")
	
	pathfollow.queue_free()


func damagePlayerBase():
	pass


func onHit(damage):
	health -= damage
	updateHPbar()
#	print("%s 被击中，受到%d 伤害，剩余生命值 %d" % [self,damage,health])
	if health <= 0:
#		print("%s死了" %self)
#		emit_signal("die",self)
		die.emit()
		pathfollow.queue_free()


func updateHPbar():
	$HPbar.value = float(health)/float(healthMax)


func _on_Area2D_area_entered(area):
#	print("敌入:",area.owner)
#	print("敌入layer:",$Area2D.collision_layer)
	var b = area.owner
	onHit(b.damage)
	pass # Replace with function body.


func _on_Area2D_area_exited(area):
#	print("敌出:",area.owner)
#	print("敌出layer:",$Area2D.collision_layer)
	pass # Replace with function body.


func jump():
	print("跳")
