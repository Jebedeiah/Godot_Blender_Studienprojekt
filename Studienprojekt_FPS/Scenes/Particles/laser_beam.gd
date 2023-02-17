extends Node3D

@onready var laser = $ParticleLaser
@onready var laser2 = $ParticleLaser2

# Emit laser particles
func emit():
	laser.emitting = true
	laser2.emitting = true
	$FreeTimer.stop()


# shorten or lengthen the laser depending on how far away the target is
func enhance(distance):
	if distance > 50:
		distance = 50
	laser.process_material.emission_box_extents.y = distance/2
	laser2.process_material.emission_box_extents.y = distance/2
	laser.position.z = -distance/2
	laser2.position.z = -distance/2


# Stop emitting the laser, but wait with freeing the particles node to show the particles fading
func freeTimerStart():
	laser.emitting = false
	laser2.emitting = false
	$FreeTimer.start()


func _on_free_timer_timeout():
	queue_free()
