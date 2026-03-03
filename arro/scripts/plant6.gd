extends AnimatedSprite2D

func _ready():
	frame = randi() % sprite_frames.get_frame_count("default")
	play("default")
