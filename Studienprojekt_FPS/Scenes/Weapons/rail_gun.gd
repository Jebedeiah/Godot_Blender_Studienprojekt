extends Node3D

@onready var animation_player1 = $AnimationPlayer
@onready var animation_player2 = $AnimationPlayer2

@onready var muzzle = $RailGun/Muzzle

@export var ammo_in_mag = 15
@export var extra_ammo = 30
@onready var mag_size = ammo_in_mag

@export var damage = 60
@export var fire_rate = 1.0

@onready var bullet = preload("res://Scenes/Weapons/bullet.tscn")
@onready var bolt = preload("res://Scenes/Particles/electric_bolt.tscn")


func fire(collision_point):
	animation_player1.play("Fire", -1.0, fire_rate)
	
	#var b = bullet.instantiate()
	var b = bolt.instantiate()
	muzzle.add_child(b)
	b.look_at(collision_point, Vector3.UP)
	b.give_impulse(animation_player2)
