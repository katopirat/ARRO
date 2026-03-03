extends Node2D

@onready var tile_map = $TileMapLayer 
@onready var player = $Player   
@export var arrows_for_this_level: int = 5

func _ready():
	if player:
		player.max_arr = arrows_for_this_level
		player.arr_left = arrows_for_this_level
	
	set_camera_limits()

func set_camera_limits():
	var camera = player.get_node_or_null("Camera2D")
	

	var map_rect = tile_map.get_used_rect()
	var cell_size = tile_map.tile_set.tile_size
	var s = tile_map.scale

	camera.limit_left = map_rect.position.x * cell_size.x * s.x + 40
	camera.limit_right = map_rect.end.x * cell_size.x * s.x - 40
	camera.limit_top = map_rect.position.y * cell_size.y * s.y
	camera.limit_bottom = map_rect.end.y * cell_size.y * s.y
	
	print("limits set : ", camera.limit_right)
