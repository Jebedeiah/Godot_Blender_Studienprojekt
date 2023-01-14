extends Node3D

@onready var laser = $ParticleLaser
@onready var laser2 = $ParticleLaser2


func emit():
	laser.emitting = true
	laser2.emitting = true
	$FreeTimer.stop()

func enhance(distance):
	if distance > 40:
		distance = 40
	laser.process_material.emission_box_extents.y = distance
	laser.position.z = -distance
	laser2.process_material.emission_box_extents.y = distance
	laser2.position.z = -distance


func freeTimerStart():
	laser.emitting = false
	laser2.emitting = false
	$FreeTimer.start()


func _on_free_timer_timeout():
	queue_free()
