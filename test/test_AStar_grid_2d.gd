extends TileMap
class_name GameMap

@onready var map : TileMap = $"."
#地图所有格子，边缘不规则
var mapAllTiles : Array[Vector2i]

@onready var camera_map: Camera2D = $Camera2D
@onready var mouse_tile_pos: Node2D = $mouseTilePos
@onready var unitsParent: Node2D = $Units



#@export var startCoord : Vector2i = Vector2i(0,0)
#@export var endCoord : Vector2i = Vector2i(3,3)

@export var playerScene : PackedScene
var player : Array[PlayerGridMove]
var units : Array[UnitGridMoveBase]

var astar_grid = AStarGrid2D.new()
#var blocks = []
var blocks : Array[Vector2i]


#当前选中的格子
var selectedTileID : Vector2i
var selectedUnit : UnitGridMoveBase

#enum {UNIT_NEUTRAL, UNIT_ENEMY, UNIT_ALLY}
#enum Named {THING_1, THING_2, ANOTHER_THING = -1}
#enum MapLayers {
#	}
enum  {
	MAPLAYERS_GROUND,
	MAPLAYERS_BLOCK,
	MAPLAYERS_MARKS,
	MAPLAYERS_PATH,
	}


#func _init() -> void:
#	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

#	设置map
#	map.clear()

#	map.add_layer(GROUND)   
#	map.set_layer_name(MAPLAYERS_GROUND,"GROUND")
#	map.add_layer(MAPLAYERS_PATH)   
#	map.set_layer_name(MAPLAYERS_PATH,"PATH")		
#	map.add_layer(MAPLAYERS_MARKS)   
#	map.set_layer_name(MAPLAYERS_MARKS,"MARKS")		

#	map.set_cell(MAPLAYERS_MARKS,startCoord,1,Vector2i(0,0),0)
#	map.set_cell(MAPLAYERS_MARKS,endCoord,1,Vector2i(1,0),0)	
	mapAllTiles = map.get_used_cells(MAPLAYERS_GROUND)
#	print(mapAllTiles.size())
	var maprect=map.get_used_rect()
	var maprectCenter = maprect.get_center()
	camera_map.position = map.map_to_local(maprectCenter)
	


#	更新导航网格，基于生成的tilemap的尺寸
	astar_grid.size = maprect.size		#整个地图的横竖格子数
	
	#每个格子的大小，设置成tilemap的tileset的tilesize
#	其实也可以不设置，如果是按id的话，和实际格子大小无关
#	astar_grid.cell_size = map.tile_set.tile_size     
	
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.default_heuristic = AStarGrid2D.HEURISTIC_EUCLIDEAN
	astar_grid.update()


#	设置障碍格,包括地图上的障碍b1和地图外的区域b2，用于导航
	var b1 = map.get_used_cells(MAPLAYERS_BLOCK)
#	print(b1)
#	判断每个格子是否在地图上，如果不在，则加入障碍格b2
	var b2:Array[Vector2i] = []
	for x in range(maprect.position.x,maprect.end.x):
		for y in range(maprect.position.y,maprect.end.y):
			var i = Vector2i(x,y)
			if not mapAllTiles.has(i):
				b2.append(i)
	blocks = b1+b2
	for bb in blocks:
#		map.set_cell(MAPLAYERS_PATH,bb,4,Vector2i(3,2),1)
#		，因为astargrid2d是从0,0开始，所以消除maprect的位置偏移
		bb -= maprect.position
		astar_grid.set_point_solid(bb,true)


##	玩家
#	player = playerScene.instantiate()
#	player.map = self
#	add_child(player)

#设置单位
	SetUnit(Vector2i(3,3))
	SetUnit(Vector2i(4,5))




#func _unhandled_input(event: InputEvent) -> void:
func _input(event: InputEvent) -> void:
	
	if event is InputEventMouseMotion:
		var mouseLocalPos = map.get_local_mouse_position()
		var mouseMapPos = map.local_to_map(mouseLocalPos)
		var mouseOverTilePos = map.map_to_local(mouseMapPos)
#		加tile的偏移量
#		p = to_global(p) + Vector2(float(TD_global.TileMapSize/2),float(TD_global.TileMapSize/2))
		mouse_tile_pos.position = mouseOverTilePos
	
	if event.is_action_pressed("click"):
		var p = get_local_mouse_position()
		var c = map.local_to_map(p)
		selectedTileID = c
		print("点击: ",selectedTileID)
		
		if blocks.has(selectedTileID):
			print("block")
#			pass
		
#		var td = map.get_cell_tile_data(0,selectedTileID)
#		if td:
#			var d = td.get_custom_data("unitLayer")
#			print(d)
		
#		重设导航格范围，其实只要按地图大小初始化一次就行了，超出地图边界的就不计算了
#		UpdateAstarGridSize(c+Vector2i.ONE)
		
#		findPath(startCoord,c)
#		print(map.get_used_cells(MAPLAYERS_PATH))
#		print(map.get_used_rect())
		



func findPath(start:Vector2i,end:Vector2i):
	var path = astar_grid.get_id_path(start,end)
	var distance = path.size()
	
	$CanvasLayer/UI/HBoxContainer/Label2.text = str(distance-1)
#	print("路径长度为 ",distance)
#	print(path)
	
	map.clear_layer(MAPLAYERS_PATH)
	map.set_cells_terrain_path(MAPLAYERS_PATH,path,0,0)
#	for i in path:
#		map.set_cell(MAPLAYERS_PATH,i,1,Vector2i(2,0),1)
	
#	var pointpath = astar_grid.get_point_path(start,end)
#	print(astar_grid.get_point_path(start,end))
	

func UpdateAstarGridSize(size:Vector2i)->void:
	astar_grid.size	= size
	astar_grid.update()
	print("astargrid导航网格大小重设为 %d,%d "  %[size.x,size.y])


#设置单位，
func SetUnit(mappos:Vector2i)->void:
	var u = playerScene.instantiate()
	unitsParent.add_child(u)
	u.position = map_to_local(mappos)
#	var td = map.get_cell_tile_data(0,mappos)
#	td.set_custom_data("unitLayer",u.get_path())
	units.append(u)
