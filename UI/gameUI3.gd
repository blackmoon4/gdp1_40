extends Control
class_name GameUI3

var map : GameTileMap

#悬停时
@onready var over_tile_coord: Label = %overTileCoord
@onready var over_tile_unit: Label = %overTileUnit




#选中时
@onready var selece_tile_coord: Label = %SeleceTileCoord
@onready var select_unit: Label = %SelectUnit
@onready var select_unit_move_range: Label = %SelectUnitMoveRange



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#	map.tile_enter.connect(_on_enter_tile)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_enter_tile(tileid : Vector2i):
	over_tile_coord.text = String("(%d , %d)" % [tileid.x, tileid.y])
	
	if map.overlayUnit:
		over_tile_unit.text = map.overlayUnit.unitName
	else:
		over_tile_unit.text = String("")
		


func _on_select_tile(tileid : Vector2i):
	
	selece_tile_coord.text = String("(%d , %d)" % [tileid.x, tileid.y])
	
	if map.selectedUnit:
		select_unit.text = map.selectedUnit.unitName
		select_unit_move_range.text = str(map.selectedUnit.moveRange)
	else:
		select_unit.text = String("")
		select_unit_move_range.text = String("")
