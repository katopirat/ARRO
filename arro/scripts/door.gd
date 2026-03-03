extends Area2D

var is_open = false

func _ready():
	body_entered.connect(_on_body_in)

func _on_button_toggled(state):
	if state: open()
	else: close()

# tween anims
func open():
	is_open = true
	var t = create_tween()
	t.tween_property(self, "modulate:a", 0.0, 0.3)
	monitoring = false 
	monitorable = false

func close():
	is_open = false
	var t = create_tween()
	t.tween_property(self, "modulate:a", 1.0, 0.3)
	monitoring = true
	monitorable = true

func _on_body_in(body):
	# check player collision
	if body.is_in_group("Player") or body.is_in_group("player"):
		if "can_move" in body: body.can_move = false
		var trans = get_tree().current_scene.find_child("TransitionLayer", true, false)
		if trans: trans.restart_fade()
