extends ColorRect

@export_file("*.tscn") var target_level
@onready var anim = get_node("../TransitionLayer/ColorRect/AnimationPlayer")

func _on_body_entered(body):
	if body.is_in_group("player") and target_level:
		anim.play("fade_in")
		
		await anim.animation_finished
		get_tree().change_scene_to_file(target_level)
