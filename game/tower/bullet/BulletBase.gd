extends Node2D
class_name BulletBase


var damage := randf_range(10.0,30.0)
#@export_range(10.0,30.0,1,"no_slider") var damage

@export var speed = 300.0
# 子弹生命 秒
@export var lifetime = 2.0

# 移动向量
var movevector :Vector2
var target

#@onready var timer : Timer = $Timer

signal applyDamage(damage)




func _ready():
#	生命周期计时，到时候自动销毁
	await get_tree().create_timer(lifetime,false).timeout
	if not self.is_queued_for_deletion():
		queue_free()
#	timer.wait_time = lifetime
	# connect("applyDamage",Callable(target,"onHit"))



#func _process(delta):
func _physics_process(delta: float) -> void:
	position += movevector * speed * delta



# 击中目标，造成伤害,延迟销毁
func _on_Area2D_area_entered(area:Area2D):
	emit_signal("applyDamage",damage)
	queue_free()


# 飞出屏幕
func _on_VisibilityEnabler2D_screen_exited():
	if not self.is_queued_for_deletion():
		queue_free()
#	free()
