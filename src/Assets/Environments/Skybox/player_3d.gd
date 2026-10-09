extends CharacterBody3D

@export var speed: float = 5.0
@export var jump_velocity: float = 4.5
@export var mouse_sensitivity: float = 0.4
@export var spring_arm_length: float = 10

@onready var camera_pivot: Node3D = $Camera_pivot
@onready var spring_arm_3d: SpringArm3D = %Camera_pivot/SpringArm3D

@onready 


var turn_min: float = -65.0
var turn_max: float = 90.0

# Get the gravity from the project settings to keep it consistent
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	# Hides the mouse and locks it to the center of the screen
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	spring_arm_3d.spring_length = spring_arm_length

func _unhandled_input(event: InputEvent) -> void:
	# Mouse look logic
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		var change_x: float = -event.relative.y * mouse_sensitivity
		camera_pivot.rotation_degrees.x += change_x
		camera_pivot.rotation_degrees.x = clamp(
			camera_pivot.rotation_degrees.x,
			turn_min,
			turn_max
		)


func _physics_process(delta: float) -> void:
	# 1. Add Gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	# 2. Handle Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	# 3. Get Input Direction (Forward, Backward, Left, Right)
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")

# Convert Input to World Direction based on where the player is looking
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	# 5. Apply the movement
	move_and_slide()
