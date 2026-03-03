extends CanvasLayer

# Vrátili jsme původní název target_level, takže si to Godot zase pamatuje
@export_file("*.tscn") var target_level
@onready var anim = $ColorRect/AnimationPlayer 

var tran = false 

func _ready():
	$ColorRect.color.a = 1 
	anim.play("fade_out")

func _on_exit_body_entered(body: Node2D):
	if body.is_in_group("Player") and not tran:
		tran = true
		anim.play("fade_in")
		await anim.animation_finished
		get_tree().change_scene_to_file(target_level)

func restart_fade():
	if tran: return
	tran = true
	anim.play("fade_in")
	await anim.animation_finished
	get_tree().reload_current_scene()

func fade_to(path: String):
	if tran: return
	tran = true
	anim.play("fade_in")
	await anim.animation_finished
	get_tree().change_scene_to_file(path)
