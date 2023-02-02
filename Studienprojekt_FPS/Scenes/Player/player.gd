extends CharacterBody3D

# Player movement
const DEFAULT_SPEED = 7.0
const RUNNING_SPEED = 14.0
const JUMP_VELOCITY = 15
const MOUSE_SENSE = 0.05
var SPEED = 8.0
var running = false
var double_jump = true

# Weapon
var collision_point
var laser_damage = 2
var laser_active = false


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var camRoot = $CamRoot
@onready var camera = $CamRoot/Camera3D
@onready var weapon = $CamRoot/Camera3D/Hand/RailGun_new
@onready var aimCast = $CamRoot/Camera3D/AimCast
@onready var hand = $CamRoot/Camera3D/Hand



# Mouse movement
func _unhandled_input(event: InputEvent) :
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			camRoot.rotate_y(deg_to_rad(-event.relative.x * MOUSE_SENSE))
			camera.rotate_x(deg_to_rad(-event.relative.y * MOUSE_SENSE))
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-89), deg_to_rad(89))


func _physics_process(delta):
	fire_weapon()
	movement(delta)


func movement(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		double_jump = true

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	elif Input.is_action_just_pressed("jump") and not is_on_floor() and double_jump:
		velocity.y = JUMP_VELOCITY
		double_jump = false

	
	# Sprint
	SPEED = DEFAULT_SPEED
	
	if Input.is_action_just_pressed("run") and not running:
		running = true
	
	if running:
		SPEED = RUNNING_SPEED

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (camRoot.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		running = false;
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()


func fire_weapon():
	# Fire the weapon
	if Input.is_action_pressed("fire") and not weapon.fireAnimPlayer.is_playing():
		
		if aimCast.is_colliding():
			var target = aimCast.get_collider()
			if target.is_in_group("Enemies"):
				target.health -= laser_damage
				
			collision_point = aimCast.get_collision_point()
			weapon.fire_laser(collision_point)
			laser_active = true
	
	if Input.is_action_just_released("fire") and not weapon.fireAnimPlayer.is_playing() and laser_active:
		weapon.stop_laser()
		laser_active = false
	
	
	if Input.is_action_just_pressed("alt_fire") and not weapon.fireAnimPlayer.is_playing() and not laser_active:
		
		if aimCast.is_colliding():
			collision_point = aimCast.get_collision_point()
			weapon.fire_projectile(collision_point)


