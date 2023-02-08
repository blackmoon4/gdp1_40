extends Control

var level


func _ready():
	pass




func _on_new_pressed():
	newgame()
#	
	


func _on_quit_pressed():
	get_tree().quit()


func newgame():
#	level = load("res://test/A.tscn")
	level = load("res://level/level_1.tscn")
	get_tree().change_scene_to_packed(level)

