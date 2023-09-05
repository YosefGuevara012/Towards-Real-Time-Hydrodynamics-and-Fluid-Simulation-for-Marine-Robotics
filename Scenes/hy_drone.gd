extends RigidBody3D

@export var float_force := 1.0
@export var water_drag := 0.05
@export var water_angular_drag := 0.1

# Global Physics varibles
@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var water = get_node('/root/World/WaterPlane')
@onready var HUD = get_node('/root/World/HUD')



# Bouyancy variables
@export_range(1020, 1029) var surface_seawater_density : int =  1020
@export var object_total_volume  = 0.0271 * 2# The total volume of the object in m^3
@export_range(0, 1) var submerged_fraction : float =  0.9
@onready var probes = $ProbeContainer.get_children()
var submerged := false

# Wind variables:
@export_range(0, 64) var wind_speed : int =  13 # Set to works as a moderate wind
@export_range(0, 360) var wind_direction : int =  270 # Set to works as a moderate wind

# Vehicle mechanics characteristics -------------------------------------------------------
@export_range(1, 6) var survey_speed : float =  3

const ANGULAR_SPEED = 0.5
var throttle = 0
var velocity = Vector3.ZERO

# Thrusters variables
var FWD_max_rpm = 3527 * 6 # from rpm to Degrees per second 360/60 for 16 V
var BWD_max_rpm = 3465 * 6 # from rpm to Degrees per second 360/60 for 16 V


# Define a signal for updating the velocity
signal vehicle_velocity(new_velocity: Vector3)

# sincronization variable:
var time = 0

func _physics_process(delta):
	
	# Vehicle control function
	get_input(delta)
	move_and_collide(velocity)	
	
	#Send sensor data
	send_sensor_data()
	
	# Ocean effect
	bouyancy()
	
	

func bouyancy():
	# Optimization: Check if object's central point is above water (you can adjust this based on your needs)
	var central_depth = water.get_height(global_position) - global_position.y
	if central_depth <= 0:
		return  # Skip checking the probes if the object is above water.
	
	# Bounyancy variables	
	submerged = false
	var probe_container_weight = 1.0 / probes.size()
	var displaced_volume = object_total_volume * submerged_fraction * probe_container_weight
	var buoyancy_force = surface_seawater_density * displaced_volume * gravity
	
	for p in probes:
		var depth = water.get_height(p.global_position) - p.global_position.y
		if depth > 0:
			submerged = true
			apply_force(Vector3.UP * buoyancy_force, p.global_position - global_position)

	
func _integrate_forces(state: PhysicsDirectBodyState3D):
	
	if submerged:
		state.linear_velocity *=  1 - water_drag
		state.angular_velocity *= 1 - water_angular_drag 
		

func get_input(delta):

	var velocity_y = velocity.y
	
	# velocity = Vector3.ZERO
	# Set the max. speed going FWD or BWD dependeing on the survey speed
	var max_speed = survey_speed * 0.514444
	# Boats moving BWD tend to reach the 70% of their maximun speed
	var throttle_direction = 0.7 if throttle > 0.0 else 1.0


	throttle = -Input.get_action_strength("ACCELERATE") + Input.get_action_strength("REVERSE")

	
	if Input.is_action_pressed("ACCELERATE") or Input.is_action_pressed("REVERSE"):
		velocity = transform.basis.z * max_speed * throttle * delta * throttle_direction 
		$collision_right_nozzle/right_nozzle/right_rotor/right_propeler.rotate_y(FWD_max_rpm * throttle * delta * throttle_direction)
		$collision_left_nozzle/left_nozzle/left_rotor/left_propeler.rotate_y(FWD_max_rpm * throttle * delta * throttle_direction)
	else:
		velocity.x = lerp(velocity.x, 0.0, 0.01)
		velocity.z= lerp(velocity.z, 0.0, 0.01)
	
	if Input.is_action_pressed("RIGHT"):
		rotate_y(-ANGULAR_SPEED * delta)
		$collision_left_nozzle/left_nozzle/left_rotor/left_propeler.rotate_y(FWD_max_rpm * delta)
		if throttle != 0.0:
			$collision_left_nozzle/left_nozzle/left_rotor/left_propeler.rotate_y(FWD_max_rpm * delta)
			$collision_right_nozzle/right_nozzle/right_rotor/right_propeler.rotate_y(FWD_max_rpm * throttle * delta * throttle_direction)
	
	if Input.is_action_pressed("LEFT"):
		rotate_y(ANGULAR_SPEED * delta)
		$collision_right_nozzle/right_nozzle/right_rotor/right_propeler.rotate_y(-FWD_max_rpm * delta)
		if throttle != 0.0:
			$collision_left_nozzle/left_nozzle/left_rotor/left_propeler.rotate_y(-FWD_max_rpm * delta)
			$collision_right_nozzle/right_nozzle/right_rotor/right_propeler.rotate_y(-FWD_max_rpm * throttle * delta * throttle_direction)	
			
	velocity.y = velocity_y
	

func send_sensor_data():
	emit_signal("vehicle_velocity", velocity.length())
