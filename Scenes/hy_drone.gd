extends RigidBody3D

@export var float_force := 1.0
@export var water_drag := 0.05
@export var water_angular_drag := 0.1

@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var water = get_node('/root/World/WaterPlane')
@onready var HUD = get_node('/root/World/HUD')

@onready var probes = $ProbeContainer.get_children()

# USING A RIDIG BODY INSTEAD A VEHICLE NODE

# max speed in kn to m/s
@export_range(1, 6) var survey_speed : float =  3
var throttle = 0
const ANGULAR_SPEED = 0.5
var time = 0
var velocity = Vector3.ZERO

# Thrusters variables
var FWD_max_rpm = 3527 * 6 # from rpm to Degrees per second 360/60 for 16 V
var BWD_max_rpm = 3465 * 6 # from rpm to Degrees per second 360/60 for 16 V
# Water Effect varibles
var submerged := false

# Define a signal for updating the velocity
signal vehicle_velocity(new_velocity: Vector3)


func _physics_process(delta):
	
	# Vehicle control function
	get_input(delta)
	move_and_collide(velocity)	
	
	#Send sensor data
	send_sensor_data()
	
	# Ocean effect
	bouyancy()

func bouyancy():
	# Bouyancty effect
	submerged = false
	for p in probes:
		var depth = water.get_height(p.global_position) - p.global_position.y 
		if depth > 0:
			submerged = true
			apply_force(Vector3.UP * float_force * gravity * depth, p.global_position - global_position)

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
