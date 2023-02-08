extends Node2D
class_name LevelBase
# 关卡

#可能出现的怪物列表
@export var enemyType = []
# 生成的怪物数
@export var enemyCount := 10
@onready var enemyspawnTimer = $Timer


# 逻辑层
@onready var LogicLayer : TileMap = %buildingLayer
@onready var mapset : TileSet = LogicLayer.tile_set

# 路线，根据
#@onready var enmeyPath : Path2D = $buildingLayer/Path2D
@onready var enmeyPath : Path2D = %Path2D

#@onready var YsortParent = $"%YSort_actors"
@onready var bullets = %bullets

#onready var gameui = preload("res://UI/gameUI.tscn")
var gameui = preload("res://UI/gameUI2.tscn")


#onready var maingameRef : TDMaingame = TD_global.getMaingame()

# 起点，不止一个
var startCells = []
# 终点，不止一个
var endCells = []
#是否是建造模式

#保存所有塔的字典，key= 格子的tilemapid，value=塔的引用
var towers = {}

var BuildMode = false

#基地核心的生命值,只有一个基地核心
@export var BaseCoreHP = 10

@onready var mouse_block = %mouseTilePos
var isShowMouseBlock = true


#== 信号 ==================================================
signal gameover


# Called when the node enters the scene tree for the first time.
func _ready():

	# 找到起点和终点
#	var startid = mapset.find_tile_by_name("start")
#	startCells = LogicLayer.get_used_cells(startid)
	# print("开始格子： ",startCells)	
#	var endid = mapset.find_tile_by_name("end")
#	endCells = LogicLayer.get_used_cells(endid)
	# print("终点格子： ",endCells)
	
#	创建ui
	gameui = gameui.instantiate() as GameUI
	gameui.maplevel = self
	$UI.add_child(gameui)



func _input(event):
#func _unhandled_input(event):
#	if event.is_action_pressed("testKey"):
#		print("a")
##		test()

#	if event.is_action_pressed("click"):
##		print("click in _input")
#		var t = load("res://game/tower/TowerBase.tscn")
#		buildTower(t)
#		pass
		
	if event is InputEventMouseButton:
		pass
	elif event is InputEventMouseMotion:
#		print("局部  ",event.position)
#		print("局部  ",get_local_mouse_position())
#		print("全局  ",event.global_position)
#		print("全局  ",get_global_mouse_position())
		var mapid = LogicLayer.local_to_map(get_local_mouse_position())
		var p = LogicLayer.map_to_local(mapid)
#		加tile的偏移量
#		p = to_global(p) + Vector2(float(TD_global.TileMapSize/2),float(TD_global.TileMapSize/2))
		mouse_block.global_position = p


func _unhandled_input(event):
#	print(event)
#	if event is InputEventScreenTouch:
#		print(event)
#	print("a")

	if event.is_action_pressed("click"):
#		print("a in _unhandled_input")

		var clickmapid = LogicLayer.local_to_map(get_local_mouse_position())

#		如果当前位置上没有存在塔，则建造新塔 
#		这里需要考虑几种情况：
		if towers.has(clickmapid):
			print("这里 %s 已经有一个塔了哟" %clickmapid)
		else :
			var t = load("res://game/tower/TowerBase.tscn")
			buildTower(t,clickmapid)
	pass






func _on_Timer_timeout():
	SpawnEnemy(enemyType)
	enemyCount -= 1
	if enemyCount <= 0:
		enemyspawnTimer.stop()


# 生成敌人单位
func SpawnEnemy(enemytype):
#	print("SpawnEnemy")	
	# 生成pathfollow
	var pf := PathFollow2D.new()
	pf.loop = false
	pf.rotates = false
	enmeyPath.add_child(pf)
	
#	从enemyType列表里随机生成
	var i = randi_range(0,enemyType.size()-1)
	var e = enemyType[i].instantiate() as EnemyBase
	e.reach.connect(OnEnmeyReached)
#	e.reach.connect(Callable(self,"OnEnmeyReached"))
	# e.connect("die",Callable(self,"destroyUnit"))
	# e.health = int(randf_range(50,200))
	# e.position = LogicLayer.map_to_local(Vector2(startCells[0]))
#	e.enmeyName = "怪物名"+enemyCount
	e.pathfollow = pf
	e.levelBase = self
#	e.maingameRef = gameui
	# e.connect("reach",Callable(self,"EnmeyReach").bind(),CONNECT_ONE_SHOT)
#	e.connect("reach",Callable(self,"OnEnmeyReached"))
#	e.add_to_group(TD_global.ENEMYGROUP)
	pf.add_child(e)

	# 在pf下生成remote,并把enmey挂上
#	var em := RemoteTransform2D.new()
#	em.remote_path = e.get_path()
#	# print(e.get_path())
#	pf.add_child(em)


# 当敌人到达基地核心时,对基地核心造成伤害
func OnEnmeyReached(enemy):
	print(enemy,"到了！")
	BaseCoreHP -= enemy.damageBase
	gameui.updateBaseCoreHP(BaseCoreHP)
#	destroyUnit(enemy)
#	
	if BaseCoreHP <= 0:
		BaseCoreDead()




#炮塔攻击响应
func OnTowerAtk(tower,bullet,target):
#	pass
	# print(tower)
	# print(bullet)
	bullet.connect("applyDamage",Callable(target,"onHit"))

#	据说这样add是线程不安全？？需要更进一步了解
#	YsortParent.add_child(bullet)

#	这样据说是线程安全的，暂时先用这个，后面再研究，尽量避免这种跨活动场景的修改场景树的方式
#	YsortParent.call_deferred("add_child",bullet)

#	或者单独把子弹放在上层，不会被其他遮挡，因为子弹小
	bullets.call_deferred("add_child",bullet)



# 销毁敌人
#func destroyUnit(enemy):
#	enemy.pathfollow.queue_free()
#	enemy.queue_free()

#	立即删除
#	enemy.pathfollow.free()
#	enemy.free()


func BaseCoreDead():
	print("核心生命值为0，死了，玩球蛋了，失败，gameover")
	get_tree().paused = true



#建造塔
func buildTower(towerType,tilemappos:Vector2i):
#	print("盖塔喽！")
	
	var t = towerType.instantiate()
	towers[tilemappos] = t
	var p = get_global_mouse_position()
	p = LogicLayer.to_local(p)
	var id = LogicLayer.local_to_map(p)
	p = LogicLayer.map_to_local(id)
	p = LogicLayer.to_global(p)
#	p += Vector2(32,32)
	t.position = p
#	t.maingame = maingame

	$buildingLayer/Towers.add_child(t)



func Lose():
	pass


func Win():
	pass
