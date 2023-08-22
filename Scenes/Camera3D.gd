extends SpringArm3D

var initial_camera_rotation: Vector3 = rotation


const CAMERA_ROTATION_SPEED= 0.5
const RETURN_ROTATION_SPEED= 0.1
const ROTATION_TIMER_TRIGGER = 3


func get_input(delta):
	
	var is_any_key_pressed = false
	# Block rotation on the Z axis
	rotation.z = 0
	
	print("rotation in x: " ,rad_to_deg(rotation.x))
	print("rotation in y: " ,rad_to_deg(rotation.y))
	print("rotation in z: " ,rad_to_deg(rotation.z))
	
	if Input.is_action_pressed("CAMERA_RIGHT"):
		is_any_key_pressed = true
		#rotate_y(CAMERA_ROTATION_SPEED * delta)
		rotation.y += CAMERA_ROTATION_SPEED * delta
		
	if Input.is_action_pressed("CAMERA_LEFT"):
		is_any_key_pressed = true
		#rotate_y(-CAMERA_ROTATION_SPEED * delta)
		rotation.y -= CAMERA_ROTATION_SPEED * delta

	if Input.is_action_pressed("CAMERA_UP"):
		is_any_key_pressed = true
		if rad_to_deg(rotation.x) <= 0:
			rotation.x += CAMERA_ROTATION_SPEED * delta
				
	if Input.is_action_pressed("CAMERA_DOWN"):	
		is_any_key_pressed = true
		if rad_to_deg(rotation.x) >= -90:
			rotation.x -= CAMERA_ROTATION_SPEED * delta

		
		
	# If no keys are pressed, return to the initial position
	if not is_any_key_pressed:
		
		rotation.x = lerp(rotation.x, initial_camera_rotation.x, RETURN_ROTATION_SPEED)
		rotation.y = lerp(rotation.y, initial_camera_rotation.y, RETURN_ROTATION_SPEED)
		#rotation.z = lerp(rotation.z, initial_camera_rotation_z, RETURN_ROTATION_SPEED)

			
			

func _physics_process(delta):
	
	get_input(delta)
