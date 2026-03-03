extends Area2D

signal toggled(active)

@export var stays = true 
var active = false

@onready var spr = $Sprite2D
@onready var sfx = $AudioStreamPlayer2D

func _ready():
	spr.modulate = Color(0.5, 0.5, 0.5)
	area_entered.connect(_on_area_in)

func _on_area_in(area):
	if area.is_in_group("arrow") and not active:
		act()

func act():
	active = true
	spr.modulate = Color(1.5, 1.5, 1.5) 
	if sfx: sfx.play()
	
	toggled.emit(true)
	
	if not stays:
		await get_tree().create_timer(2.0).timeout
		deact()

func deact():
	active = false
	spr.modulate = Color(0.5, 0.5, 0.5)
	toggled.emit(false)
