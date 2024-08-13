extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var camera_sensitivity = 50
@onready var player_camera = %Camera3D
var look_dir : Vector2
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move left", "move right","move forward","move backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	rotate_camera(delta)

func _input(event):
	if event is InputEventMouseMotion:
		look_dir = event.relative *.01
		print(look_dir)
	
func rotate_camera(delta: float):
	
	rotation.y -= look_dir.x * camera_sensitivity * delta
	player_camera.rotation.x = clamp(player_camera.rotation.x - look_dir.y * camera_sensitivity * delta, -1.5, 1.5)
	
	look_dir = Vector2.ZERO
