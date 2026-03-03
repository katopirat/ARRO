extends Button

func _ready():
	pressed.connect(_on_click)

func _on_click():
	get_tree().reload_current_scene()
