extends Node3D

var mouse_move
var sway_threshold = 5
var sway_lerp = 3

@export var sway_left : Vector3
@export var sway_right : Vector3
@export var sway_normal : Vector3


# Save mouse movement in an variable
func _input(event):
	if event is InputEventMouseMotion:
		mouse_move = -event.relative.x


# If there is mouse movement sway the weapon in the direction of that movement
func _process(delta):
	if not Input.is_action_pressed("fire"):
		if mouse_move != null:
			if mouse_move > sway_threshold:
				rotation = rotation.lerp(sway_left, sway_lerp * delta)
			elif mouse_move < -sway_threshold:
				rotation = rotation.lerp(sway_right, sway_lerp * delta)
			else:
				rotation = rotation.lerp(sway_normal, sway_lerp * delta)
	else:
		rotation = rotation.lerp(sway_normal, 12 * delta)
