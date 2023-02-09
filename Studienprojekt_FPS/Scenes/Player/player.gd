extends CharacterBody3D

# Player movement
const DEFAULT_SPEED = 7.0
const RUNNING_SPEED = 12.0
const JUMP_VELOCITY = 12
const MOUSE_SENSE = 0.05
var SPEED = DEFAULT_SPEED
var running = false
var double_jump = true
var horizontal_velocity = Vector3()
var horizontal_acceleration = 7
var air_acceleration = 1
var normal_acceleration = 7

# Weapon
var collision_point
var laser_damage = 2
var laser_active = false
var lc = null

# Health
var health = 500


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var laser_collision = preload("res://Scenes/Particles/laser_collision.tscn")
@onready var world = get_parent()
@onready var camRoot = $CamRoot
@onready var camera = $CamRoot/Camera3D
@onready var weapon = $CamRoot/Camera3D/Hand/RailGun_new
@onready var aimCast = $CamRoot/Camera3D/AimCast
@onready var hand = $CamRoot/Camera3D/Hand


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


# If Escape is pressed, pause the game
func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("ui_cancel"):
		$Pause.pause()


# Mouse movement to rotate the first person POV
func _input(event):
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			camRoot.rotate_y(deg_to_rad(-event.relative.x * MOUSE_SENSE))
			camera.rotate_x(deg_to_rad(-event.relative.y * MOUSE_SENSE))
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-89), deg_to_rad(89))


func _physics_process(delta):
	fire_weapon()
	movement(delta)
	
	if health <= 0:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().change_scene_to_file("res://Scenes/Menu/game_over.tscn")


# Code for Player movement
func movement(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		horizontal_acceleration = air_acceleration # Continue moving forward while in the air even when not pressing a movement key
	else:
		double_jump = true
		horizontal_acceleration = normal_acceleration

	# Handle Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	elif Input.is_action_just_pressed("jump") and double_jump:
		velocity.y = JUMP_VELOCITY
		double_jump = false

	
	# Sprint
	SPEED = DEFAULT_SPEED
	
	if Input.is_action_just_pressed("run") and not running:
		running = true
	
	if running:
		SPEED = RUNNING_SPEED

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (camRoot.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		horizontal_velocity = horizontal_velocity.lerp(direction * SPEED, horizontal_acceleration * delta)
		velocity.x = horizontal_velocity.x
		velocity.z = horizontal_velocity.z
	else:
		running = false;
		horizontal_velocity = horizontal_velocity.lerp(Vector3.ZERO, horizontal_acceleration * delta)
		velocity.x = horizontal_velocity.x
		velocity.z = horizontal_velocity.z
	
	move_and_slide()
	touchingRadioactiveWall()


# Lose health as long as the player touches a radioactive obstacle
func touchingRadioactiveWall():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider().get_parent().is_in_group("radioactive"):
			health -= 1


# Fire laser or bolt
func fire_weapon():
	# Fire the laser as long as the button is pressed and deal damage if an enemy is hit
	if Input.is_action_pressed("fire") and not weapon.fireAnimPlayer.is_playing():
		
		if aimCast.is_colliding():
			var target = aimCast.get_collider()
			if target.is_in_group("Enemies"):
				target.health -= laser_damage
				
			collision_point = aimCast.get_collision_point()
			weapon.fire_laser(collision_point)
			if not lc:
				lc = laser_collision.instantiate()
				get_parent().add_child(lc)
			lc.position = collision_point
			lc.get_node("CollisionParticle").emitting = true
			laser_active = true
	
	# Stop firing the laser when the button is released
	if Input.is_action_just_released("fire") and not weapon.fireAnimPlayer.is_playing() and laser_active:
		weapon.stop_laser()
		lc.get_node("CollisionParticle").emitting = false
		laser_active = false
	
	
	# Fire the electric bolt
	if Input.is_action_just_pressed("alt_fire") and not weapon.fireAnimPlayer.is_playing() and not laser_active:
		
		if aimCast.is_colliding():
			collision_point = aimCast.get_collision_point()
			weapon.fire_projectile(collision_point)


