extends ColorRect

# Node Calling
@onready var vehicle = get_node('/root/World/HyDrone')
@onready var current_time = "13:00"

# Defining local variables
var time_passed = 0


func _physics_process(delta):
	
	set_values(delta)
	

func set_values(delta):
	
	
	# Time passed calculation
	time_passed += delta

	# Getting the vehicle tranform
	var vehicle_position = vehicle.global_transform.origin
	var vehicle_rotation = vehicle.global_transform.basis.get_euler()
	
	# Vehicle coordinates
	# snapped funtion is a function for round the values
	# DMS Coordiante system added
	if $"../Environmental_variables/XYZ_coord_checkbox".button_pressed == true:
		$Latitude.text = "LAT:    " + str(snapped(vehicle_position.x,0.000001)) 
		$Longitude.text = "LON:    " + str(snapped(vehicle_position.z,0.000001))
	else:
		$Latitude.text = "LAT:    " + str(decimal_to_geographic(vehicle_position.x))
		$Longitude.text = "LON:    " + str(decimal_to_geographic(vehicle_position.z))

	# Time calculation process
	$Time.text = "HOB:    " + str(convert_seconds_to_time(time_passed))
	$"../Environmental_variables/TIME".text = "TIME:    " + str(convert_seconds_to_time(add_seconds_to_time(current_time, time_passed)))
	# str(convert_seconds_to_time(add_seconds_to_time(current_time, time_passed)))
	
	# Vehicle rotation
	$Yaw.text = "YAW:    " + str(snapped(rad_to_deg(vehicle_rotation.y),0.01))
	$Pitch.text = "PITCH:   " + str(snapped(rad_to_deg(vehicle_rotation.x),0.01))
	$Roll.text = "ROLL:   " + str(snapped(rad_to_deg(vehicle_rotation.z),0.01))
	
	# Depth data
	
	# Speed Data

	
	# Vehicle Odometer data
	var heading = snapped(rad_to_deg(vehicle_rotation.y),0)
	
	if heading <= 0:
		$Heading_panel/Heading_value.text = str(-heading) + "°"
	else: 
		$Heading_panel/Heading_value.text = str(360 - heading) + "°"
	

func add_seconds_to_time(time_str, seconds_to_add):

	var time_parts = time_str.split(":")

	var hours = int(time_parts[0])
	var minutes = int(time_parts[1])

	if hours > 23 or minutes > 59:
		$"../Environmental_variables/Current_time".text = "Imcorrect time"

	var total_seconds = hours * 60 * 60 + minutes * 60 + seconds_to_add

	return total_seconds


# Function to convert decimal degrees to degrees, minutes, and seconds
func decimal_to_geographic(coordinate) :
	var degrees = int(coordinate)
	
	var decimal_minutes = abs(coordinate - degrees) * 60
	var minutes = int(decimal_minutes)
	var seconds = (decimal_minutes - minutes) * 60
	
	return  str(degrees)+"°"+str(minutes)+"'"+str(snapped(seconds,0))+"''"
	

func convert_seconds_to_time(seconds):
	
	var remaining_seconds = seconds
	
	var days = int(remaining_seconds / (24 * 60 * 60))
	remaining_seconds -= days * 24 * 60 * 60
	
	var hours = int(remaining_seconds / (60 * 60))
	remaining_seconds -= hours * 60 * 60
	
	var minutes = int(remaining_seconds / 60)
	remaining_seconds -= minutes * 60
	
	remaining_seconds = snapped(remaining_seconds,0)
	
	if days > 0: 
		return str(days)+"d:"+ str(hours)+"h:"+str(minutes)+"m:"+str(remaining_seconds)+"s"
	else:
		return str(hours)+"h:"+str(minutes)+"m:"+str(remaining_seconds)+"s"
		
