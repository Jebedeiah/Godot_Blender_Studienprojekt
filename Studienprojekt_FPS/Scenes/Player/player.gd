extends CharacterBody3D


const DEFAULT_SPEED = 5.0
const RUNNING_SPEED = 10.0
const JUMP_VELOCITY = 4.5
const SWAY = 60

var SPEED = 5.0
var running = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var camRoot = $CamRoot
@onready var camera = $CamRoot/Camera3D
@onready var weapon = $CamRoot/Camera3D/Hand/RailGun
@onready var aimCast = $CamRoot/Camera3D/AimCast
@onready var hand = $CamRoot/Camera3D/Hand
@onready var handLoc = $CamRoot/Camera3D/HandLoc

func _ready():
	hand.set_as_top_level(true)

func _unhandled_input(event: InputEvent) :
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			camRoot.rotate_y(-event.relative.x * 0.001)
			camera.rotate_x(-event.relative.y * 0.001)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(60))


func _process(delta):
	hand.global_transform.origin = handLoc.global_transform.origin
	hand.rotation.y = lerp_angle(hand.rotation.y, camRoot.rotation.y, SWAY * delta)
	hand.rotation.x = lerp_angle(hand.rotation.x, camera.rotation.x, SWAY * delta)


func _physics_process(delta):
	
	movement(delta)
	fire_weapon()


func movement(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

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
	if Input.is_action_just_pressed("fire"):
		
		if aimCast.is_colliding():
			var target = aimCast.get_collider()
			if target.is_in_group("Enemy"):
				print("hit enemy")
				target.health -= weapon.damage
		
		
	if Input.is_action_just_pressed("alt_fire") and not weapon.animation_player1.is_playing():
		
		if aimCast.is_colliding():
			var target = aimCast.get_collider()
			var collision_point = aimCast.get_collision_point()
			weapon.fire(collision_point)


