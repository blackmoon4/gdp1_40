extends Node2D
class_name TDMapBase
# 关卡





#@export_category("地图")

@onready var game_tilemap: TileMap = $"."

# 路线，根据
#先来一条路径,路径由从tilemap上的路径set自动生成
var pathTiles : Array[Vector2i] = []
#var enmeyPath : Array[Path2D]
var enmeyPath : Path2D

#Astar2D
var astar_map = AStar2D.new()
#数组的id就是当前单位寻路图的节点id，值就是对应tilemap上的格子坐标Vector2i
var astar_map_tiles = []

#onready var maingameRef : TDMaingame = TD_global.getMaingame()

# 起点，不止一个
var startCells = []
# 终点，不止一个
var endCells = []

#保存所有塔的字典，key= 格子的tilemapid，value=塔的引用
var towers = {}

var BuildMode = false

#基地核心的生命值,只有一个基地核心
@export var BaseCoreHP = 10


#@export_category("单位")

#可能出现的怪物列表
@export var enemyType = []

# 生成的怪物数
@export var enemyCount := 10
#@onready var enemyspawnTimer = $Timer

#@onready var bullets = %bullets

#onready var gameui = preload("res://UI/gameUI.tscn")
#@export var gameui_ps : PackedScene
#var gameui : GameUI
@onready var gameui : GameUI = $CanvasLayer/GameUI2

@onready var mouse_block = $mouseTilePos
var isShowMouseBlock = true

@export_group("地图")
@export_subgroup("我")
@export var aaa:int

@export_group("单位")
@export var bbb:int
@export_subgroup("敌人")
@export var ccc:int


#== 信号 ==================================================
signal gameover





# Called when the node enters the scene tree for the first time.
func _ready():

	# 找到起点和终点
#	var startid = mapset.find_tile_by_name("start")
#	startCells = game_tilemap.get_used_cells(startid)
	# print("开始格子： ",startCells)	
#	var endid = mapset.find_tile_by_name("end")
#	endCells = game_tilemap.get_used_cells(endid)
	# print("终点格子： ",endCells)
	
#	创建ui
#	gameui = gameui_ps.instantiate() as GameUI
	gameui.map_ref = self
#	$CanvasLayer.add_child(gameui)

	findPath(Vector2i(0,0), Vector2i(10,10))

	pass
	



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
		var mapid = game_tilemap.local_to_map(get_local_mouse_position())
		var p = game_tilemap.map_to_local(mapid)
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

		var clickmapid = game_tilemap.local_to_map(get_local_mouse_position())

#		如果当前位置上没有存在塔，则建造新塔 
#		这里需要考虑几种情况：
		if towers.has(clickmapid):
			print("这里 %s 已经有一个塔了哟" %clickmapid)
		else :
#			var t = load("res://game/tower/TowerBase.tscn")
#			buildTower(t,clickmapid)
			pass
	pass




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
	# e.position = game_tilemap.map_to_local(Vector2(startCells[0]))
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
#	bullets.call_deferred("add_child",bullet)



# 销毁敌人
#func destroyUnit(enemy):
#	enemy.pathfollow.queue_free()
#	enemy.queue_free()

#	立即删除
#	enemy.pathfollow.free()
#	enemy.free()


func BaseCoreDead():
	print("核心生命值为0, 死了,玩球蛋了,失败,gameover")
	get_tree().paused = true



#建造塔
func buildTower(towerType,tilemappos:Vector2i):
#	print("盖塔喽！")
	
	var t = towerType.instantiate()
	towers[tilemappos] = t
	var p = get_global_mouse_position()
	p = game_tilemap.to_local(p)
	var id = game_tilemap.local_to_map(p)
	p = game_tilemap.map_to_local(id)
	p = game_tilemap.to_global(p)
#	p += Vector2(32,32)
	t.position = p
#	t.maingame = maingame

	$buildingLayer/Towers.add_child(t)


#返回一条从起点到终点格子的路径，是一条 Tile 列表，用来生成真正的 path2D
func findPath(startTile : Vector2i, endTile:Vector2i) -> Array[Vector2i]:
	var path : Array[Vector2i] = []
#	var id = astar_map.get_id_path(0,10)
#	print(id)
	return path



func Lose():
	pass


func Win():
	pass


#构建用来进行AStar寻路的图，  这里就是用来找出角色的可移动区域的节点
func buildAStar2DTiles(start:Vector2i,step:int):
	astar_map.clear()
	astar_map_tiles.clear()
	
	var frontier = []    #搜索的边缘
	frontier.append(start)
#	var searched = []    #搜索过的，加入到当前寻路的图中
#	searched.append(start)
	var cost = {}    #每个点的移动力消耗，不能超过最大移动力
	cost[start] = 0
	astar_map_tiles.append(start)
	var astar_map_id = 0
	astar_map.add_point(astar_map_id,Vector2i(0,0))
	
	while not frontier.is_empty():
		var current = frontier.pop_front()
		var cid = astar_map_tiles.find(current)
		var cn = cost[current]+1
		
		for next in getMapTileNeighbors(current):
#			var cid = astar_map_id.find(current)
			if not cost.keys().has(next):
				cost[next] = cn
				if cost[next] <= step:
					frontier.append(next)
					astar_map_tiles.append(next)
#					var newastar_map_id = astar_map_id+1
					var newid = astar_map_tiles.size()-1
					astar_map.add_point(newid, Vector2i(0,0))
					astar_map.connect_points(cid,newid)
#					astar_map_id = newastar_map_id



#  地图上的格子的相邻格子，返回
func getMapTileNeighbors(tileID:Vector2i) -> Array[Vector2i]:
# 	var c = map.get_surrounding_cells(tileID)
	var c2 : Array[Vector2i]= []
# 	for c1 in c:
# 		if mapTiles.has(c1) and not blocks.has(c1):
# 			c2.append(c1)
# #	print(c2)
	return(c2)
