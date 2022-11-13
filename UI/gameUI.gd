extends Control
class_name GameUI


# var player : PlayerBase

#onready var player : PlayerBase = maingame.playerRef


var i = 0
var showRange = true

#onready var maingame : TDMaingame = TD_global.getMaingame()
var maplevel
@onready var core_hp_max = maplevel.BaseCoreHP
@onready var core_hp = core_hp_max

@onready var test_1 = %test1
@onready var label_base_core_hp_left = %baseCoreHpLeft

# Called when the node enters the scene tree for the first time.
func _ready():
#	core_hp_max = maplevel.BaseCoreHP
	updateUI()
	pass



func setupUI(level):
	label_base_core_hp_left.text = String(level.BaseCoreHP)


func updateUI():
	updateBaseCoreHP(core_hp)
	pass



func updateBaseCoreHP(hp):
	label_base_core_hp_left.text = "%d" %hp
	


func _on_pause_toggled(button_pressed):
	get_tree().paused = button_pressed


func _on_test_1_pressed():
#	var t = load("res://game/enemy/EnemyBase.tscn")
	maplevel.SpawnEnemy(maplevel.enemyType)


func _on_show_range_pressed() -> void:
	TD_global.isShowAllTowerRange = not TD_global.isShowAllTowerRange
	get_tree().call_group(TD_global.TOWERGROUP,"setShowRange",TD_global.isShowAllTowerRange)
