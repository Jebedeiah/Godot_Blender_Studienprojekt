extends RigidBody3D

var shoot = false

@export var damage = 150
@export var bullet_speed = 40



func _on_area_3d_body_entered(body):
	if body.is_in_group("Enemy"):
		body.health -= damage
	queue_free()


func start_up(anim_player):
	anim_player.play("Vibration", -1.0, 1)


func _on_life_timer_timeout():
	queue_free()


func _on_impulse_timer_timeout():	
	set_as_top_level(true)
	apply_impulse(-transform.basis.z * bullet_speed, transform.basis.z)
