extends Node2D

func _on_start_pressed() -> void:
	$SfxClick.play()
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	$TransitionLayer.fade_to("res://scenes/levels/lvl1.tscn")

func _on_volume_pressed() -> void:
	$SfxClick.play()
	pass # Replace with function body.

func _on_credits_pressed():
	$SfxClick.play()
	$CreditsPanel.show()
	$VBoxContainer.hide()

func _on_btn_close_credits_pressed():
	$SfxClick.play()
	$CreditsPanel.hide()
	$VBoxContainer.show()
	
func _on_quit_pressed() -> void:
	$SfxClick.play()
	
	await get_tree().create_timer(0.15).timeout 
	get_tree().quit()


func _on_button_mouse_entered() -> void:
	$SfxHover.pitch_scale = randf_range(0.9, 1.1)
	$SfxHover.play()
