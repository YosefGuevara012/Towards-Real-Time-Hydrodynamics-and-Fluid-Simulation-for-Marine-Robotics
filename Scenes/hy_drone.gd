extends RigidBody3D

@export var float_force := 1.0
@export var water_drag := 0.05
@export var water_angular_drag := 0.05

@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var water = get_node('/root/World/WaterPlane')

# @onready var probes = $ProbeContainer.get_children()
@onready var probes = $ProbeContainer.get_children()

#Vehicle controller variables


#var horse_power  = 200
#var accel_speed = 20
#
#var steer_angle = deg_to_rad(30)
#var steer_speed = 3
#
#var brake_power = 40
#var brake_speed = 40


#------------USING A RIDIG BODY INSTEAD A VEHICLE NODE

var max_speed = 3.09 #Aprox 6 kn


var SPEED = 0.05
const ROTATION_SPEED = 0.5


#----------Vehicle Varibales

@export var engine_force = 5.80
var velocity = Vector3.ZERO

var direction = Vector3.FORWARD


# Water Effect varibles
var submerged := false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	
	#Vehicle controller
	
	#------------USING A RIDIG BODY INSTEAD A VEHICLE NODE
#	var inputVector = Vector3.ZERO
#
#	var throttle_input = Input.get_action_strength("ui_up")
#	print(throttle_input)
	
#	var throttle_input = -Input.get_action_strength("ui_up") + Input.get_action_strength("ui_down")
#	engine_force = lerp(engine_force,throttle_input * horse_power, accel_speed * delta)
#	##
#	var steer_input = -Input.get_action_strength("ui_right") + Input.get_action_strength("ui_left")
#	steering = lerp(steering, steer_input * steer_angle, steer_speed * delta)
#
#	var brake_input = Input.get_action_strength("BRAKE")
#	brake = brake_input * brake_power
	
	
	############################
	get_input(delta)
	move_and_collide(direction)	
	##############################
	
	

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
	
	#################
	
	direction = Vector3(Input.get_action_strength("RIGHT") - Input.get_action_strength("LEFT"),
						 0, 
						 Input.get_action_strength("REVERSE") - Input.get_action_strength("ACCELERATE"))
						
	$HUD/Label.text = "direction: " + str(direction)
	$HUD/Label2.text = "direction.length(): " + str(direction.length())

	#################S
	
	
#	var velocity_y = velocity.y
#	velocity = Vector3.ZERO

#	if Input.is_action_pressed("ACCELERATE"):
#		velocity -=transform.basis.z * SPEED
#	if Input.is_action_pressed("REVERSE"):
#		velocity += transform.basis.z * SPEED
#	if Input.is_action_pressed("RIGHT"):
#		rotate_y(-ROTATION_SPEED * delta)
#	if Input.is_action_pressed("LEFT"):	
#		rotate_y(ROTATION_SPEED * delta)
	
#	velocity.y = velocity_y
