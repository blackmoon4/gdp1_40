@tool
extends Resource
class_name ItemProperty


#物品属性（物品的属性名字写在下面，用于后面方便获取与设置物品的属性）
#这样，我们只用在这里添加键值，然后修改的时候也不会影响以后的通过key值去设置属性的代码
const ItemProperty = {
	Name = "item_name",
	Texture = "item_texture",
	Price = "price",
	Damage = "damage",
	MoveSpeed = "move_speed",
	AttackSpeed = "attack_speed",
	AAA = "aaa",
}



signal item_texture_changed(texture_)   #物品贴图发生改变信号

@export var item_name = ""
@export var item_texture : Texture:
#	get:
#		return item_texture
	set(value):
		item_texture = value
#		emit_signal("item_texture_changed",value)
		item_texture_changed.emit(value)
		
@export_multiline var item_description
@export var price : int = 0
@export var damage : int = 0
@export var move_speed : float = 1.0
@export var attack_range : float = 1.0


#var ItemProperty = {
#	item_name : item_name,
#	item_texture : item_texture,
#	price : price,
#	damage : damage,
#	move_speed : move_speed,
#	attack_range : attack_range,
#	item_description : item_description,
#}


#返回物品属性
func get_property() -> Dictionary:
	var property_list = ItemProperty.values()    #获取所有属性名
	var data = {}
	for property in property_list:
		var p_value = get(property)    #???
		data[property] = p_value
	return data


#设置物品属性
func set_property(property_dict : Dictionary) -> void:
	for key in property_dict:
		var value = property_dict[key]
		set(key,value) 		#???
