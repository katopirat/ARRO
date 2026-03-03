extends Area2D

var vel = Vector2.ZERO 
var grav = 1000.0
var stuck = false
var bounces = 1
var spd_loss = 0.6

enum ArrType { NORM, BOUNCE, FIRE }
var type = ArrType.NORM

@onready var col = $StaticBody2D/CollisionShape2D
@onready var ray = $RayCast2D
@onready var trail = $Trail
@onready var fx = $ImpactParticles

func _ready():
	ray.target_position = Vector2(60, 0)
	rotation = vel.angle()
	
	# color setup
	match type:
		ArrType.NORM:
			trail.default_color = Color(1, 1, 1, 0.3) 
			fx.modulate = Color(1, 1, 1, 0.5)
		ArrType.BOUNCE:
			trail.default_color = Color(0.3, 1, 0.3, 0.3) 
			fx.modulate = Color(0.3, 1, 0.3, 0.6)
		ArrType.FIRE:
			trail.default_color = Color(1, 0.3, 0.2, 0.3) 
			fx.modulate = Color(1, 0.4, 0.2, 0.7)

func _physics_process(delta):
	if stuck: return

	# raycast tunneling fix
	if ray.is_colliding():
		var obj = ray.get_collider()
		if obj.is_in_group("wall"):
			var hit_pos = ray.get_collision_point()
			
			if type == ArrType.BOUNCE and bounces > 0:
				var n = ray.get_collision_normal()
				vel = vel.bounce(n) * spd_loss
				play_fx(hit_pos)
				global_position = hit_pos + n * 5
				bounces -= 1
				rotation = vel.angle()
				return
			else:
				play_fx(hit_pos)
				stuck = true
				vel = Vector2.ZERO
				global_position = hit_pos - transform.x * 50
				
				if is_instance_valid(trail): trail.stop = true 
				if col: col.set_deferred("disabled", false)
				return

	# apply grav
	vel.y += grav * delta
	position += vel * delta
	rotation = vel.angle()

func play_fx(pos):
	fx.global_position = pos
	fx.emitting = true 

func _on_body_entered(body):
	if not stuck and body.is_in_group("wall") and type != ArrType.BOUNCE:
		stuck = true
		vel = Vector2.ZERO
		if is_instance_valid(trail): trail.stop = true
		play_fx(global_position)
		if col: col.set_deferred("disabled", false)
