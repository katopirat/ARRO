extends CharacterBody2D

const SPD = 300.0
const JMP = -500.0
var grav = ProjectSettings.get_setting("physics/2d/default_gravity")

var arr_scene = preload("res://scenes/Arrow.tscn")
var arr_left = 5
var max_arr = 5

var pulled = false
var pow = 0.0
var max_pow = 1000.0
var dir = Vector2.ZERO

var atk = false
var fired = false

enum ArrType { NORM, BOUNCE, FIRE }
var cur_arr = ArrType.NORM

@onready var line = $Line2D
@onready var vis = $Visuals
@onready var muz = $Visuals/Muzzle
@onready var ui = get_node("../CanvasLayer/Label")
@onready var anim = $Visuals/AnimatedSprite2D

var coy_timer = 0.0
var coy_frames = 0.15

var can_move = true

var step_times = [0.13, 0.43, 0.64, 0.89, 1.15, 1.41, 1.66]

func _ready():
	line.hide()
	line.top_level = true
	line.z_index = 5

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and arr_left > 0 and not atk:
			pulled = true
			line.show()
		elif pulled:
			pulled = false
			line.hide()
			$SfxBowPull.play(2)
			do_attack()
	
	if Input.is_key_pressed(KEY_R): get_tree().reload_current_scene()
	
	# switch ammo
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_1: cur_arr = ArrType.NORM
		if event.keycode == KEY_2: cur_arr = ArrType.BOUNCE
		if event.keycode == KEY_3: cur_arr = ArrType.FIRE

func do_attack():
	if arr_left <= 0: return
	atk = true
	fired = false
	anim.play("normal")
	await anim.animation_finished
	atk = false

func _physics_process(delta):
	var was_in_air = not is_on_floor()
	# coyote time logic
	if not is_on_floor():
		velocity.y += grav * delta
		coy_timer -= delta
	else:
		coy_timer = coy_frames

	if atk:
		velocity.x = 0
		vis.scale.x = 1 if get_global_mouse_position().x > global_position.x else -1
			
		if anim.frame == 6 and not fired:
			shoot()
			fired = true
			
		move_and_slide()
	else:
		if not can_move:
			velocity.x = 0
			move_and_slide()
			anim.play("idle")
		else:
			if Input.is_action_just_pressed("ui_accept") and coy_timer > 0:
				velocity.y = JMP
				coy_timer = 0
				
				# --- ZVUK SKOKU ---
				$SfxJump.pitch_scale = randf_range(0.9, 1.1)
				$SfxJump.play(0.05)
				# ------------------
				

			var d = Input.get_axis("ui_left", "ui_right")
			velocity.x = d * SPD if d else move_toward(velocity.x, 0, SPD)
			
			move_and_slide()
			
			# sprite flip
			if is_on_floor() and velocity.x == 0:
				vis.scale.x = 1 if get_global_mouse_position().x > global_position.x else -1
			elif d != 0:
				vis.scale.x = 1 if d > 0 else -1

			# anim states
			if not is_on_floor(): anim.play("jump")
			elif velocity.x == 0: anim.play("idle")
			else: anim.play("run")

	if pulled: calc_traj(delta)
	
	ui.text = str(arr_left) + "x | Mode: " + ArrType.keys()[cur_arr]
	
	# --- ZVUK DOPADU ---
	if was_in_air and is_on_floor():
		$SfxLand.pitch_scale = randf_range(0.8, 1.2)
		$SfxLand.play(0.30)
	# -------------------

func calc_traj(delta):
	var m_pos = get_global_mouse_position()
	var diff = m_pos - muz.global_position
	
	pow = clamp(diff.length() * 10, 500, max_pow)
	dir = diff.normalized() * pow
	
	line.global_position = Vector2.ZERO
	var pts = []
	var p_pos = muz.global_position
	var p_vel = dir
	
	var pred_bounce = 1 if cur_arr == ArrType.BOUNCE else 0
	var space = get_world_2d().direct_space_state
	var step = 0.02

	for i in range(60):
		pts.append(p_pos)
		p_vel.y += 1000.0 * step
		var n_pos = p_pos + (p_vel * step)
		
		var q = PhysicsRayQueryParameters2D.create(p_pos, n_pos)
		q.exclude = [self]
		q.collision_mask = 1
		
		var res = space.intersect_ray(q)
		
		if res:
			if pred_bounce > 0:
				p_pos = res.position
				p_vel = p_vel.bounce(res.normal) * 0.6
				pred_bounce -= 1
			else:
				pts.append(res.position)
				break
		else:
			p_pos = n_pos
	
	line.points = pts

func shoot():
	if arr_left <= 0: return
	$SfxShoot.play()
	var a = arr_scene.instantiate()
	
	a.type = cur_arr
	a.global_position = muz.global_position
	a.vel = dir
	
	get_parent().add_child(a)
	arr_left -= 1

func _on_animated_sprite_2d_frame_changed():
	if anim.animation == "run":
		if anim.frame == 2 or anim.frame == 6:
			var random_start = step_times.pick_random()
			
			$SfxStep.pitch_scale = randf_range(2, 3)
			$SfxStep.play(random_start)
			
			get_tree().create_timer(0.17).timeout.connect(func(): $SfxStep.stop())
