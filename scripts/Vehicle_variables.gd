extends ColorRect

# Calling vehicle node
@onready var vehicle = get_node('/root/World/HyDrone')


# Defining local variables
var time_passed = 0


func _physics_process(delta):
	
	# Time passed calculation
	time_passed += delta
	
	# Getting the vehicle tranform
	var global_position = vehicle.global_transform.origin
	var self_rotation = vehicle.global_transform.basis.get_euler()
	
	# Vehicle coordinates
	# snapped funtion is a function for round the values
	$Latitude.text = "LAT    " + str(snapped(global_position.x,0.0001)) 
	$Longitude.text = "LON    " + str(snapped(global_position.y,0.0001))
	$Time.text = "TIME    " + str(snapped(time_passed,0))
	
	# Vehicle rotation
	$Yaw.text = "YAW    " + str(snapped(rad_to_deg(self_rotation.y),0.01))
	$Pitch.text = "PITCH    " + str(snapped(rad_to_deg(self_rotation.x),0.01))
	$Roll.text = "ROLL    " + str(snapped(rad_to_deg(self_rotation.z),0.01))

