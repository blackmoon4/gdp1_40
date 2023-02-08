extends TileMap
class_name GameTileMap

@onready var map : TileMap = $"."
#地图所有使用到的格子，不包括空白，边缘不规则，包括整个障碍物等
var mapTiles : Array[Vector2i]
#障碍
var blocks : Array[Vector2i]
#可通行的格子
var mapPassTiles : Array[Vector2i]



#地图所有格子数据
#key是地图上的格子坐标 Vector2i，  value是格子数据 GameMapTileData
var mapData = {}

@onready var camera_map: Camera2D = $Camera2D
@onready var mouse_tile_pos: Node2D = $mouseTilePos
@onready var unitsParent: Node2D = $Units
@onready var select_tile_mark: Node2D = $SelectTileMark
@onready var gameui: GameUI3 = $CanvasLayer/UI


@export var unitPS : PackedScene
#生成的单位数量
@export var spawnUnitNum : int = 3

#var astar_grid = AStarGrid2D.new()
var astar_map = AStar2D.new()
#数组的id就是当前单位寻路图的节点id，值就是对应tilemap上的格子坐标Vector2i
var astar_map_tiles = []
#key是单位在地图上的坐标，value是单位的引用
var units = {}
##当前单位寻路图的字典，key是节点id：int，value是对应tilemap上的格子坐标Vector2i
#寻路，值为当前路径的坐标数组Vector2i
var unitpath = []


#当前鼠标悬停的格子
var overlayTileID : Vector2i = Vector2i(0,0)
#当前选中的格子
var selectedTileID : Vector2i
#
var overlayUnit : UnitGridMoveBase
var selectedUnit : UnitGridMoveBase
#单位可以移动
var unitCanMove : bool = false



#信号=======================================================
#鼠标进入格子,
#tileCoord 鼠标当前进入的格子的坐标
signal tile_enter(tileCoord:Vector2i)
#signal tile_enter(tileID:int)

#选择格子
signal tile_select(tileCoord:Vector2i)

#选中单位
#signal select_unit
signal select_unit(unit : UnitGridMoveBase)



enum  {
	MAPLAYERS_GROUND,
	MAPLAYERS_BLOCK,
	MAPLAYERS_MARKS,
	MAPLAYERS_PATH,
	MAPLAYERS_UNIT,
	MAPLAYERS_MOVERANGE
	}

#  MAPLAYERS_UNIT 层上的单位阵营种类
enum {
	MAPLAYERS_UNITSET_X_PLAYER = 0,
	MAPLAYERS_UNITSET_X_ENEMEY = 1,
	MAPLAYERS_UNITSET_X_MIDDLE = 2,
	MAPLAYERS_UNITSET_X_FRIEND = 3
}


#方法 ==============================================

func _ready() -> void:
	gameui.map = self
	tile_enter.connect(gameui._on_enter_tile)
	
#	设置map
	mapTiles = map.get_used_cells(MAPLAYERS_GROUND)
	
#	print(mapTiles.size())
	var maprect=map.get_used_rect()
	var maprectCenter = maprect.get_center()
	camera_map.position = map.map_to_local(maprectCenter)


##	更新导航网格，基于生成的tilemap的尺寸
#	astar_grid.size = maprect.size		#整个地图的横竖格子数
#	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
#	astar_grid.default_heuristic = AStarGrid2D.HEURISTIC_EUCLIDEAN
#	astar_grid.update()


#	设置障碍格,包括地图上的障碍b1和地图外的区域b2，用于导航
	var b1 = map.get_used_cells(MAPLAYERS_BLOCK)
#	print(b1)
#	判断每个格子是否在地图上，如果不在，则加入障碍格b2
	var b2:Array[Vector2i] = []
	for x in range(maprect.position.x,maprect.end.x):
		for y in range(maprect.position.y,maprect.end.y):
			var i = Vector2i(x,y)
			if not mapTiles.has(i):
				b2.append(i)
	blocks = b1+b2
#	for bb in blocks:
#		bb -= maprect.position
#		astar_grid.set_point_solid(bb,true)
	
	mapPassTiles = mapTiles
	for b in blocks:
		mapPassTiles.erase(b)
#	print(mapPassTiles)
	
	tile_enter.connect(OnEnterMapTile)
	tile_select.connect(OnSelectMapTile)
	
	#设置单位
	SetUnit()




#func _unhandled_input(event: InputEvent) -> void:
func _input(event: InputEvent) -> void:
	
	if event is InputEventMouseMotion:
#		鼠标移动则取消单位的可移动模式
		unitCanMove = false
		
		var mouseLocalPos = map.get_local_mouse_position()
		var p = map.local_to_map(mouseLocalPos)
		if overlayTileID != p and mapTiles.has(p):
			overlayTileID = p
			mouse_tile_pos.position = map.map_to_local(overlayTileID)
			tile_enter.emit(overlayTileID)
		
	
	if event.is_action_released("click"):
		selectedTileID = overlayTileID
		tile_select.emit(selectedTileID)
		

	if event.is_action_pressed("click"):
		unitCanMove = true
#		map.set_cell(MAPLAYERS_UNIT,selectedTileID,2,Vector2i(randi_range(0,3),0))



#使用astargrid2d
#func findPath(start:Vector2i,end:Vector2i):
#	var path = astar_grid.get_id_path(start,end)
#	var distance = path.size()
#
##	$CanvasLayer/UI/HBoxContainer/Label2.text = str(distance-1)
##	print("路径长度为 ",distance)
##	print(path)
#
#	map.clear_layer(MAPLAYERS_PATH)
#	map.set_cells_terrain_path(MAPLAYERS_PATH,path,0,0)
##	for i in path:
##		map.set_cell(MAPLAYERS_PATH,i,1,Vector2i(2,0),1)


#使用astar2d
#每次根据所选单位的移动力和位置得到寻路图，在这个 图里进行寻路
func findPath(target:Vector2i):
#	buildAStar2DTiles(selectedUnit.mappos, selectedUnit.moveRange)
	var path = astar_map.get_id_path(0, astar_map_tiles.find(target))
#	print(path)
	unitpath = []
	for p in path:
		unitpath.append(astar_map_tiles[p])
	map.clear_layer(MAPLAYERS_PATH)
	map.set_cells_terrain_path(MAPLAYERS_PATH,unitpath,0,1)
#	for i in path:
#		map.set_cell(MAPLAYERS_PATH,i,1,Vector2i(2,0),1)



#创建移动路径path和pathfollow,并把要移动的单位移动到目标格子，有动画
func MoveFollowPath():
#	移动 的 时候禁止输入，暂时是这样
	set_process_input(false)
	
	var pathnode = Path2D.new()
	pathnode.curve = Curve2D.new()
	for i in unitpath:
		var p = map.map_to_local(i)
		pathnode.curve.add_point(p)
#	print(pathnode.curve.point_count)
	unitsParent.add_child(pathnode)
	
	var pathfollow = PathFollow2D.new()
	pathfollow.loop = false
	pathfollow.rotates = false
	pathnode.add_child(pathfollow)
	
	var rt = RemoteTransform2D.new()
	rt.remote_path = selectedUnit.get_path()
#	rt.use_global_coordinates = false
	rt.update_rotation = false
	rt.update_scale = false
	pathfollow.add_child(rt)
#	准备好路径了 
	
	
#	创建tween
#	var tw = get_tree().create_tween()
#	var tw = get_tree().create_tween().bind_node(pathnode)
	var tw = pathnode.create_tween()
#	tw.set_parallel(false)
	tw.tween_property(pathfollow,"progress_ratio",1,1.0).set_trans(Tween.TRANS_SINE)
#	tw.tween_property(pathfollow,"progress_ratio",1,1.0).bind_node(pathnode).set_trans(Tween.TRANS_SINE)
#	tw.tween_property(pathfollow,"progress",1000,2.0).set_trans(Tween.TRANS_SINE)

#	到达后
	tw.tween_callback(onUnitReached.bind(selectedTileID))
	tw.tween_callback(self.set_process_input.bind(true))
	tw.tween_callback(pathnode.queue_free)
#	tw.kill()

	unitCanMove = false




#当单位到达时
func onUnitReached(tileID):
	unitpath.clear()
	var preunitmappos = selectedUnit.mappos
	units.erase(preunitmappos)

#	清除之前的单位层格子
#	更新新的层格子
	var sid = map.get_cell_source_id(MAPLAYERS_UNIT,preunitmappos)
	var ac = map.get_cell_atlas_coords(MAPLAYERS_UNIT,preunitmappos)
#	map.set_cell(MAPLAYERS_UNIT,selectedUnit.mappos,-1,Vector2i(-1,-1))
	map.erase_cell(MAPLAYERS_UNIT,preunitmappos)
	map.set_cell(MAPLAYERS_UNIT,tileID,sid,ac)

#	更新新位置id
	units[tileID] = selectedUnit
	selectedUnit.mappos = tileID
	selectedUnit.setPlayerPosition(tileID)

	OnSelectMapTile(tileID)




#func moveUnitFollowPath():
#	pass



#设置单位，在可行走的格子上随机摆放spawnUnitNum个
#func SetUnit(mappos:Vector2i)->void:
func SetUnit()->void:
	var t = mapPassTiles.duplicate()
	for i in spawnUnitNum:
		var u = unitPS.instantiate()
		var p = t.pick_random()
		u.mappos = p
		u.unitName += str(p)
		u.map = self
		u.position = map_to_local(p)
		unitsParent.add_child(u)

#		给单位随机设置一个阵营
		map.set_cell(MAPLAYERS_UNIT,p,2,Vector2i(randi_range(0,3),0))

		select_unit.connect(u._on_selected)
	#	var td = map.get_cell_tile_data(0,mappos)
	#	td.set_custom_data("unitLayer",u.get_path())
	#	units.append(u)
		units[p] = u
		t.erase(p)




#鼠标 悬停在 格子上
#如果悬停格子上 有单位，则设置悬停单位
#如果悬停格子上无单位，则设置悬停单位为null
func OnEnterMapTile(tileID:Vector2i):
#	if units.has(overlayTileID):
	if IsTileHasUnit(overlayTileID):
		overlayUnit = units[overlayTileID]
	else:
		overlayUnit = null

	#如果之前有选中的单位，并且当前格子在其可移动范围内，则显示出单位到当前格的寻路路径
	if selectedUnit and astar_map_tiles.has(tileID):
		findPath(tileID)



#点击选中格子
func OnSelectMapTile(tileID:Vector2i):
	select_tile_mark.position = map.map_to_local(selectedTileID)
	
	if overlayUnit:
		selectedUnit = overlayUnit
		buildAStar2DTiles(tileID,selectedUnit.moveRange)
		showUnitMoveRange()
		selectedUnit._on_selected()
#	如果有选中单位，并且当前有路径
#	elif selectedUnit and (unitpath.size()>1):
	elif selectedUnit and (unitpath.size()>1) and unitCanMove:
		MoveFollowPath()
	else:
		selectedUnit = null
		unitpath.clear()
		clearAstarMap()
		map.clear_layer(MAPLAYERS_MOVERANGE)
		map.clear_layer(MAPLAYERS_PATH)
	
	gameui._on_select_tile(tileID)
	
	if blocks.has(selectedTileID):
		print("block")
	
#	var nc = getMapTileNeighbors(selectedTileID)
#	map.clear_layer(MAPLAYERS_MOVERANGE)
#	for i in nc:
#		map.set_cell(MAPLAYERS_MOVERANGE,i,4,Vector2i(3,2),3)



#  地图上的格子的相邻格子，返回
func getMapTileNeighbors(tileID:Vector2i) -> Array[Vector2i]:
	var c = map.get_surrounding_cells(tileID)
	var c2 = []
	for c1 in c:
		if mapTiles.has(c1) and not blocks.has(c1):
			c2.append(c1)
#	print(c2)
	return(c2)



#用洪水填充算法找出可移动范围内的格子
#start是起始位置
#step是可移动的步数
func floodTiles(start:Vector2i,step:int) -> Array[Vector2i]:
#	var tiles = []
	
#	广度优先算法
	#frontier = Queue()
	#frontier.put(start)
	#visited = {}
	#visited[start] = True
	#
	#while not frontier.empty():
	#    current = frontier.get()
	#for next in graph.neighbors(current):
	#if next not in visited:
	#            frontier.put(next)
	#            visited[next] = True

	var frontier = []
#	var current
#	var visited = {}
	frontier.append(start)
#	visited[start] = true
	var cost = {}
	cost[start] = 0
	
	while not frontier.is_empty():
#		var current = frontier.front()
		var current = frontier.pop_front()
		for next in getMapTileNeighbors(current):
#			var newcost = cost[current] + 1
			if not cost.keys().has(next):
				cost[next] = cost[current] +1
				if cost[next] < step:
					frontier.append(next)
#				visited[next] = true

	return(cost.keys())


func showUnitMoveRange():
	map.clear_layer(MAPLAYERS_MOVERANGE)
	if selectedUnit:
#		print(astar_map_tiles)
		#	var nc = getMapTileNeighbors(selectedTileID)
		for i in astar_map_tiles:
			map.set_cell(MAPLAYERS_MOVERANGE,i,4,Vector2i(3,2),3)



#构建用来进行AStar寻路的图，  这里就是用来找出角色的可移动区域的节点
func buildAStar2DTiles(start:Vector2i,step:int):
	clearAstarMap()
	
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


func clearAstarMap() -> void:
	astar_map.clear()
	astar_map_tiles.clear()



#当前格子是否有单位，用
func IsTileHasUnit(tileID:Vector2i) -> bool:
#	var ut = map.get_used_cells(MAPLAYERS_UNIT)
#	var td = map.get_cell_tile_data(MAPLAYERS_UNIT,tileID)
#	var a = map.get_cell_atlas_coords(MAPLAYERS_UNIT,tileID)
	var u = map.get_used_cells(MAPLAYERS_UNIT).has(tileID)
#	if u:
#		print(tileID," 这里有单位")
#	else:
#		print(tileID," 这里无单位")
	return(u)
