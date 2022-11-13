extends Node2D
class_name PlayerInput


@onready var playerRef : PlayerBase = owner
#onready var playerRef : PlayerBase = $".."
# onready var gameRef = playerRef.maingame as TDMaingame


# Called when the node enters the scene tree for the first time.
func _ready():
	# print("input ready")
	# print(playerRef)
	# print(gameRef)
	pass # Replace with function body.



func _input(event):
	if event.is_action_pressed("testKey"):
#		print("testKey")
		testKey()
		pass



# func _input_event(event):
# 	if event.is_action_pressed("testKey"):
# 		# print(event)
# 		pass

# 监测事件
func _unhandled_input(event):
	if event.is_action_pressed("click"):
		# print("click")

		# var maplogiclayer = playerRef.maingame.mapref.LogicLayer
		# var pos = get_global_mouse_position() 
		# pos = maplogiclayer.to_local(pos)
		# var id = maplogiclayer.local_to_map(pos)
		# pos = maplogiclayer.map_to_local(id)
		# pos = maplogiclayer.to_global(pos)
		# pos += Vector2(32,32)
		playerRef.buildTower()
		# print(gameRef)



# 持续监测
func _process(_delta):
	pass



func testKey():
#	print("测试按键")
	var t = get_tree().get_nodes_in_group(TD_global.TOWERGROUP)
	for tt in t:
		tt=tt as TowerBase
		
#		print(tt)
		get_tree().call_group(TD_global.TOWERGROUP,"testgroup",tt.name)
		
	pass
	
