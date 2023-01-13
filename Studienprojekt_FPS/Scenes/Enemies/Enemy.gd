extends CharacterBody3D

var health = 300


func _process(delta):
	if health <= 0:
		queue_free()
