extends Control

func _ready():
	pass


func _on_new_pressed():
	newgame()


func _on_quit_pressed():
	get_tree().quit()


func newgame():
#	加载战旗模式地图
	var level = load("res://game/ZhanqiGame/GameTileMap.tscn")
	
	#加载塔防模式地图:
#	var level = load("res://game/TDGame/GameTDMap.tscn")
	
	get_tree().change_scene_to_packed(level)
