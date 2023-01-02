extends Node2D
class_name UnitGridMoveBase

var map:GameMap    #游戏地图
var mappos:Vector2i   #玩家角色当前位置坐标
var moveDirection:Vector2i   #角色移动方向
var moveRange:int = 4   #角色移动力，每次移动的格数


#当进入一个格子时,tileid是进入的格子
signal tile_entered(tileid)

#当该单位被选中
signal selected(unit)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#	setPlayerPosition(Vector2i(0,0))
	
	
	tile_entered.connect(_on_tile_entered)
	selected.connect(_on_selected)
	pass # Replace with function body.


func _unhandled_input(_event: InputEvent) -> void:
	pass


#把玩家设置到地图格子位置
func setPlayerPosition(map_pos:Vector2i):
	var p = map.map_to_local(map_pos)
	position = p


#朝一个方向移动
func MoveToDirection(direction:Vector2i) -> void:
	var newpos = mappos + direction
	setPlayerPosition(newpos)
	mappos = newpos
	tile_entered.emit(newpos)


#移动到指定格子，使用astargrid导航
func MoveToPos(targetpos:Vector2i)->void:
	var path = map.astar_grid.get_id_path(mappos,targetpos)
	var distance = path.size()
	print("路径长度为 ",distance)
	print(path)
	
	map.clear_layer(map.MAPLAYERS_PATH)
	map.set_cells_terrain_path(map.MAPLAYERS_PATH,path,0,0)
#	for i in path:
#		map.set_cell(MAPLAYERS_PATH,i,1,Vector2i(2,0),1)
	
#	var pointpath = astar_grid.get_point_path(start,end)
#	print(astar_grid.get_point_path(start,end))


func _on_tile_entered(tileid) -> void:
	print(tileid)
	pass


func _on_selected(unit)->void:
	print(unit)
