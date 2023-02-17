extends AnimatableBody3D

#var shoot = false

var damage = 220
var bullet_speed = 70
var motion = Vector3()
var bh = null
var world_bh

@onready var world = get_node("/root/World")
@onready var bolt_hit = preload("res://Scenes/Particles/bolt_hit.tscn")


func _ready():
	bh = bolt_hit.instantiate()
	world.add_child(bh)
	world_bh = world.get_node("BoltHit")

# If a bolt hits an enemy, it deals damage to it and gets freed
func _on_area_3d_body_entered(body):
	if body.is_in_group("Enemies"):
		body.health -= damage
	
	world_bh.position = position
	world_bh.get_node("hitParticles").emitting = true
	world_bh.get_node("hitAudio").play()
	queue_free()


# Vibration animation during charging a shot
func start_up(anim_player):
	anim_player.play("Vibration", -1.0, 1)


# Free the bolt when it travels through the air for too long without hitting anything
func _on_life_timer_timeout():
	queue_free()


# Shoot the bolt from the weapon
func _physics_process(delta):
	move_and_collide(motion * delta)


# Set the bolt as top level as soon as it leaves the weapon, so it won't be influenced by player movement anymore
func _on_impulse_timer_timeout():
	set_as_top_level(true)
	motion = Vector3(-transform.basis.z * bullet_speed)
