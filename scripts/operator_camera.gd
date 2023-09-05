extends Camera3D

const CAMERA_DISPLACEMENT_SPEED = 1
const CAMERA_ROTATION_SPEED = 0.5
const RETURN_ROTATION_SPEED = 0.1
const ROTATION_TIMER_TRIGGER = 3

func _physics_process(delta):
	# Vehicle control function
	get_input(delta)

func get_input(delta):
	var movement = Vector3()
	var camera_up_down_displacement: bool = true

	# Handle Forward/Backward movement
	if Input.is_action_pressed("OPERATOR_CAMERA_FORWARD"):
		movement.z -= CAMERA_DISPLACEMENT_SPEED
	elif Input.is_action_pressed("OPERATOR_CAMERA_BACKWARD"):
		movement.z += CAMERA_DISPLACEMENT_SPEED

	# Handle Left/Right rotation
	if Input.is_action_pressed("OPERATOR_CAMERA_RIGHT"):
		rotate_y(-CAMERA_ROTATION_SPEED * delta)
	elif Input.is_action_pressed("OPERATOR_CAMERA_LEFT"):
		rotate_y(CAMERA_ROTATION_SPEED * delta)

	# Handle Up/Down movement
	
	if Input.is_action_pressed("RIGHT") or Input.is_action_pressed("LEFT"):
		camera_up_down_displacement = false 
	
	if camera_up_down_displacement == true:
		if Input.is_action_pressed("OPERATOR_CAMERA_UP"):
			movement.y += CAMERA_DISPLACEMENT_SPEED
		elif Input.is_action_pressed("OPERATOR_CAMERA_DOWN"):
			movement.y -= CAMERA_DISPLACEMENT_SPEED
	
	# Apply the movement
	translate(movement * delta)
