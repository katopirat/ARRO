extends Area2D

@onready var lbl = $Control

func _ready():
	lbl.modulate.a = 0.0 # hide text
	body_entered.connect(_on_in)
	body_exited.connect(_on_out)

func _on_in(body):
	if body.is_in_group("Player") :
		var t = create_tween()
		t.tween_property(lbl, "modulate:a", 1.0, 0.3)
func _on_out(body):
	if body.is_in_group("Player") :
		var t = create_tween()
		t.tween_property(lbl, "modulate:a", 0.0, 0.3)
