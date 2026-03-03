extends Sprite2D 

var spd = 1.5   
var amp = 0.1    
var time_s = 0.0 

func _ready():
	time_s = randf() * 10.0
	spd += randf() * 0.5 

func _process(delta):
	var t = (Time.get_ticks_msec() / 1000.0) + time_s
	rotation = sin(t * spd) * amp
