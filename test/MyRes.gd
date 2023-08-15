@tool
extends Resource
class_name MyRes01


@export var var1_name := "namename"
@export_range(1,100,1) var var2_a := 10:
	set(value):
		var2_a=value
		var4 = value*2
@export var var3 := Vector2i()
@export var var4 : int = 0
@export var tex : Texture2D
@export_enum("aa","bb","cc","dd") var var5_enum : int = 0

@export_range(0.0,1.0,0.01,"range") var var6_range := 0.5
#@export_range(0, 20) var number
#@export_range(-10, 20) var number
#@export_range(-10, 20, 0.2) var number: float
#
#@export_range(0, 100, 1, "or_greater") var power_percent
#@export_range(0, 100, 1, "or_greater", "or_less") var health_delta
#
#@export_range(-3.14, 3.14, 0.001, "radians") var angle_radians
#@export_range(0, 360, 1, "degrees") var angle_degrees
#@export_range(-8, 8, 2, "suffix:px") var target_offset
