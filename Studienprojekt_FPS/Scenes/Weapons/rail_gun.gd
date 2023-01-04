extends Node3D

@onready var animation_player = $AnimationPlayer

@export var ammo_in_mag = 15
@export var extra_ammo = 30
@onready var mag_size = ammo_in_mag

@export var damage = 10
@export var fire_rate = 1.0


func fire():
	animation_player.play("Fire", -1.0, fire_rate)
