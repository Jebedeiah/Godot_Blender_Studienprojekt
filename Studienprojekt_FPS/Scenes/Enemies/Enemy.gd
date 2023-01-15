extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D
@onready var sight = $Sight

var health = 300
const SPEED = 3.0
const TURN_SPEED = 3
var distance_to_player = 0

func _physics_process(delta):
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_location()
	var new_velocity = (next_location - current_location).normalized() * SPEED
	
	nav_agent.set_velocity(new_velocity)


func update_target_location(target_location):
	nav_agent.set_target_location(target_location)
	distance_to_player = global_transform.origin.distance_to(target_location)
	if distance_to_player < 20:
		sight.look_at(target_location, Vector3.UP)
		rotate_y(deg_to_rad(sight.rotation.y * TURN_SPEED))


func _process(delta):
	print(health)
	if health <= 0:
		queue_free()	


func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	velocity = velocity.move_toward(safe_velocity, .25)
	move_and_slide()
