extends AnimatableBody3D

var shoot = false

var damage = 150
var bullet_speed = 50
var motion = Vector3(0,0,0)



func _on_area_3d_body_entered(body):
	if body.is_in_group("Enemies"):
		body.health -= damage
	queue_free()


func start_up(anim_player):
	anim_player.play("Vibration", -1.0, 1)


func _on_life_timer_timeout():
	queue_free()

func _physics_process(delta):	
	move_and_collide(motion * delta)

func _on_impulse_timer_timeout():
	set_as_top_level(true)
	motion = Vector3(-transform.basis.z * bullet_speed)
