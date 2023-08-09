extends SpringArm3D

var mouse_direction = Vector2(0,0)
var initial_camera_rotation_x = rotation.x
var initial_camera_rotation_y = rotation.y

func _input(event):
	
	if Input.is_action_pressed("FREE_CAMERA"):
		if event is InputEventMouseMotion:
			mouse_direction = event.relative
			rotation.y -= deg_to_rad(mouse_direction.x * 0.1)
			rotation.x -= deg_to_rad(mouse_direction.y * 0.1)
		elif Input.is_action_pressed("RESET_CAMERA"):
			rotation.x = initial_camera_rotation_x
			rotation.y = initial_camera_rotation_y
			
