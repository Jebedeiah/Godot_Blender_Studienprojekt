extends CharacterBody3D

class_name Enemy

@export var explosion : PackedScene

@onready var Enemy = preload("res://Scenes/Particles/explosion.tscn")
@onready var nav_agent = $NavigationAgent3D
@onready var sight = $Sight
@onready var player = get_tree().get_first_node_in_group("Player")
@onready var world = get_parent()

var health = 300
const SPEED = 8.0
const TURN_SPEED = 4
var distance_to_player = 0

var current_location
var next_location
var new_velocity
var e = null

signal enemy_killed




# Calculate velocity for next movement
func _physics_process(_delta):
	current_location = global_transform.origin
	next_location = nav_agent.get_next_path_position()
	new_velocity = (next_location - current_location).normalized() * SPEED
	
	nav_agent.set_velocity(new_velocity)


# Make enemies look at where they are walking until they are close to the player, then look at the player
func update_target_location(target_location):
	nav_agent.set_target_position(target_location)
	distance_to_player = global_transform.origin.distance_to(target_location)
	if distance_to_player < 20:
		sight.look_at(target_location, Vector3.UP)
	elif abs((nav_agent.get_next_path_position() - sight.global_transform.origin).y) > 0.99: # Switch UP Vector if sight tries to look straight up or down because look_at gets confused
		sight.look_at(nav_agent.get_next_path_position(), Vector3(0,0,1))
	else:
		sight.look_at(nav_agent.get_next_path_position(), Vector3.UP)
	
	rotate_y(deg_to_rad((sight.rotation.y) * TURN_SPEED)) # Rotate the eye of the enemy to look at the player


# Free enemy when its health becomes 0
func _process(_delta):
	if health <= 0:
		emit_signal("enemy_killed")


# Computed velocity is needed for collsion avoidance between enemies
func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	velocity = velocity.move_toward(safe_velocity, .25)
	move_and_slide()


# Show game over Scene when the player gets reached by an enemy
func _on_touch_area_body_entered(body):
	if body == player:
		body.health = 0


func _on_aura_area_body_entered(body):
	if body == player:
		$AuraTimer.start()


func _on_aura_area_body_exited(body):
	if body == player:
		$AuraTimer.stop()


func _on_aura_timer_timeout():
	player.health -= 3


func _on_enemy_killed():
	if not e:
		e = explosion.instantiate()
		world.add_child(e)
	e.position = position
	e.get_node("ParticleExplosion").emitting = true
	queue_free()
