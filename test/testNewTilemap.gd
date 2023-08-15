extends TileMap

@onready var test_new_tilemap: TileMap = $"."



func _ready() -> void:
#	test_new_tilemap.set_cell(0,Vector2i(0,0),1,Vector2i(2,1))
	pass
	


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		var a = get_local_mouse_position()
		a = test_new_tilemap.local_to_map(a)
		print("点击了 ",a)
		var x = test_new_tilemap.get_surrounding_tiles(a)
		print(x)
		
		test_new_tilemap.clear_layer(1)
		for xx in x:
			test_new_tilemap.set_cell(1,xx,1,Vector2i(2,1))
