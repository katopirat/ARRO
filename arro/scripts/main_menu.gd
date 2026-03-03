extends Node2D

func _on_start_pressed() -> void:
	$TransitionLayer.fade_to("res://scenes/levels/lvl1.tscn")

func _on_volume_pressed() -> void:
	pass # Replace with function body.

func _on_credits_pressed():
	$CreditsPanel.show()
	$VBoxContainer.hide()

func _on_btn_close_credits_pressed():
	$CreditsPanel.hide()
	$VBoxContainer.show()
	
func _on_quit_pressed() -> void:
	get_tree().quit()
