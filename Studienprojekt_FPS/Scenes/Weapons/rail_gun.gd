extends Node3D

@onready var animation_player1 = $AnimationPlayer
@onready var animation_player2 = $AnimationPlayer2

@onready var muzzle = $RailGun/Muzzle

@export var damage = 60

@onready var bullet = preload("res://Scenes/Weapons/bullet.tscn")
@onready var bolt = preload("res://Scenes/Particles/electric_bolt.tscn")


func fire(collision_point):
	animation_player1.play("Fire", -1.0, 1.0)
	
	#var b = bullet.instantiate()
	var b = bolt.instantiate()
	muzzle.add_child(b)
	b.look_at(collision_point, Vector3.UP)
	b.give_impulse(animation_player2)
