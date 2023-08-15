extends Node2D


# "1" is an "initialized value". These DO NOT trigger the setter.
# If someone set the value as "two" from the Inspector, this would be an
# "exported value". These DO trigger the setter.
@export var test: String = "1" :
	get:
		return test # TODOConverter40 Non existent get function 
	set(mod_value):
		mod_value  # TODOConverter40 Copy here content of set_test

func _init():
	# "three" is an "init assignment value".
	# These DO NOT trigger the setter, but...
	# These DO trigger the setter. Note the `self` prefix.
	self.test = "3"
	test = "2"



func _ready():
	# These DO trigger the setter. Note the `self` prefix.
	self.test = "5"
	test = "4"
#	print("Setting: ", test)


func set_test(value):
	test = value
	print("Setting: ", test)
