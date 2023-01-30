extends Node3D

@onready var fireAnimPlayer = $FireAnimPlayer
@onready var vibAnimPlayer = $VibAnimPlayer

@onready var muzzle = $Muzzle

@onready var bullet = preload("res://Scenes/Weapons/bullet.tscn")
@onready var bolt = preload("res://Scenes/Particles/electric_bolt.tscn")
@onready var laser = preload("res://Scenes/Particles/laser_beam.tscn")

var l = null
var distance


func fire_projectile(collision_point):
	fireAnimPlayer.play("Fire", -1.0, 1.0)
	
	var b = bolt.instantiate()
	muzzle.add_child(b)
#	print(muzzle.global_transform.origin)
	b.look_at(collision_point, Vector3.UP)
	b.start_up(vibAnimPlayer)
	
	
func fire_laser(collision_point):
	if not l:
		l = laser.instantiate()
		muzzle.add_child(l)
	
	vibAnimPlayer.play("Vibration", -1.0, 1.0)
	vibAnimPlayer.get_animation("Vibration").set_loop_mode(true)
	l.look_at(collision_point, Vector3.UP)
	distance = muzzle.global_transform.origin.distance_to(collision_point)
	l.enhance(distance);
	l.emit()


func stop_laser():
	if l:
		vibAnimPlayer.get_animation("Vibration").set_loop_mode(false)
		vibAnimPlayer.stop()
		l.freeTimerStart()
