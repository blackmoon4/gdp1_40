@tool
extends CenterContainer

@onready var texture_rect: TextureRect = $TextureRect
@onready var item_name: Label = $ItemName


#@export var item_property : ItemProperty:
@export var item_property : Resource:
	set(value):
		if not value is ItemProperty:
			item_property = null
			texture_rect.texture = null
#			print("不")
			return
		item_property = value as ItemProperty
		
		# texture_rect 为 null 时代表还没加载到场景中
		# 所以我们要等待当前节点发出 ready 信号
		if texture_rect ==null:
			# 当前节点发出 ready 信号后再继续执行后面的语句
			await ready
#			yield(self,"ready")
			pass
		
		# 连接资源的 goods_texture_changed 信号
		# goods_texture_changed 信号附加有 texture
		# 连接到 texture_rect 的 set_texture 方法上
		# goods_texture 属性改变的时候，
		# 将会调用 texture_rect 的 set_texture 方法
#		item_property.item_texture_changed.connect(Callable(texture_rect,"set_texture"))
		if not item_property.item_texture_changed.is_connected(texture_rect.set_texture):
			item_property.item_texture_changed.connect(texture_rect.set_texture)
		texture_rect.texture = value.item_texture
		
		item_name.text = item_property.item_name
		
#		print("是")







# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
#	pass # Replace with function body.
