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
const MAX_SPEED = 6 * 0.514444 
# Engine force, 388 W For the T200 for 16V
var thorttle = 0

var SPEED = 0.05
const ANGULAR_SPEED = 0.5
var time = 0
# Vehicle Variables

@export var engine_force = 5.80
var velocity = Vector3.ZERO

# Water Effect varibles
var submerged := false

# Define a signal for updating the velocity
signal velocity_updated(new_velocity: Vector3)

func _physics_process(delta):
	
	# Vehicle control function
	get_input(delta)
	move_and_collide(velocity)	
	
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
	
	thorttle = -Input.get_action_strength("ACCELERATE") + Input.get_action_strength("REVERSE")
	
	if Input.is_action_pressed("ACCELERATE"):
		velocity = transform.basis.z * MAX_SPEED * thorttle * delta
	elif Input.is_action_pressed("REVERSE"):
		velocity = transform.basis.z * MAX_SPEED * thorttle *delta
	else:
		velocity.x = lerp(velocity.x, 0.0, 0.01)
		velocity.z= lerp(velocity.z, 0.0, 0.01)
	
	if Input.is_action_pressed("RIGHT"):
		rotate_y(-ANGULAR_SPEED * delta)
	elif Input.is_action_pressed("LEFT"):	
		rotate_y(ANGULAR_SPEED * delta)

	velocity.y = velocity_y
	


