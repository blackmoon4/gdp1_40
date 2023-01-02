@tool
#程序化生成场景
extends TileMap
class_name TilemapGenarator

@export var a : int = 3

@onready var tile_map_Ref: TileMap = $"."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tile_map_Ref.clear()
	MapGen()


# # Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta: float) -> void:
# 	pass



#生成地图
func MapGen()->void:
	print("开始自动生成地图")
#	var cellCoord:Vector2i = Vector2i(1,1)

	tile_map_Ref.set_cell(0,Vector2i(1,1),0,Vector2i(1,0),1)
	tile_map_Ref.set_cell(0,Vector2i(1,2),0,Vector2i(1,0),1)
	tile_map_Ref.set_cell(0,Vector2i(2,2),0,Vector2i(1,0),1)



