extends Line2D

@export var max_len = 15
var stop = false 

func _ready():
	top_level = true
	clear_points()

func _process(_delta):
	if not stop and is_instance_valid(get_parent()):
		add_point(get_parent().global_position)
	
	if stop or get_point_count() > max_len:
		if get_point_count() > 0:
			remove_point(0)
