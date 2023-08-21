extends SpringArm3D

var mouse_direction = Vector2(0,0)
var initial_camera_rotation_x = rotation.x
var initial_camera_rotation_y = rotation.y

const CAMERA_ROTATION_SPEED= 0.5
const RETURN_ROTATION_SPEED= 0.1

#func _input(event):
	
#	if Input.is_action_pressed("FREE_CAMERA"):
#		if event is InputEventMouseMotion:
#			mouse_direction = event.relative
#			rotation.y -= deg_to_rad(mouse_direction.x * 0.1)
#			rotation.x -= deg_to_rad(mouse_direction.y * 0.1)
#		elif Input.is_action_pressed("RESET_CAMERA"):
#			rotation.x = initial_camera_rotation_x
#			rotation.y = initial_camera_rotation_y


func get_input(delta):
	
	var is_any_key_pressed = false
	# Block rotation on the Z axis
	rotation.z = 0
	
	var angle_x = 0
	if Input.is_action_pressed("CAMERA_RIGHT"):
		rotate_y(CAMERA_ROTATION_SPEED * delta)
		is_any_key_pressed = true
	if Input.is_action_pressed("CAMERA_LEFT"):
		rotate_y(-CAMERA_ROTATION_SPEED * delta)
		is_any_key_pressed = true
	if Input.is_action_pressed("CAMERA_UP"):
		is_any_key_pressed = true
		if rad_to_deg(rotation.x) <= 90:
			rotate_x(-CAMERA_ROTATION_SPEED * delta)
	if Input.is_action_pressed("CAMERA_DOWN"):	
		is_any_key_pressed = true
		if rad_to_deg(rotation.x) <= 0:
			rotate_x(CAMERA_ROTATION_SPEED * delta)
	
	# If no keys are pressed, return to the initial position
	if not is_any_key_pressed:
		rotation.x = lerp(rotation.x, initial_camera_rotation_x, RETURN_ROTATION_SPEED)
		rotation.y = lerp(rotation.y, initial_camera_rotation_y, RETURN_ROTATION_SPEED)

	
	

	# Your other input handling code can go here...

func _physics_process(delta):
	
	get_input(delta)
