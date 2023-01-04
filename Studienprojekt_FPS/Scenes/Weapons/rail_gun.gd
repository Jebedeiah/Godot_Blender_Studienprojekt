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


func fire():
	animation_player1.play("Fire", -1.0, fire_rate)
	
	var b = bullet.instantiate()
	muzzle.add_child(b)
	b.set_global_transform(muzzle.get_global_transform())
	b.give_impulse(animation_player2)
