extends RigidBody3D

var shoot = false

@export var damage = 100
@export var bullet_speed = 5

@onready var TW = create_tween()


func _on_area_3d_body_entered(body):
	if body.is_in_group("Enemy"):
		body.health -= damage
	queue_free()


func _on_timer_timeout():
	queue_free()


func give_impulse(anim_player):
	anim_player.play("Vibration", -1.0, 1)
	TW.tween_property(self, "scale", Vector3(15,15,15), 0.8)
	await TW.finished
	TW.tween_property(self, "scale", Vector3(1,1,1), 0.1)	
	set_as_top_level(true)
	anim_player.stop()
	apply_impulse(transform.basis.x * bullet_speed, -transform.basis.x)
