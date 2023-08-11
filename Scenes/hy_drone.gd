extends RigidBody3D

@export var float_force := 1.0
@export var water_drag := 0.05
@export var water_angular_drag := 0.05

@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var water = get_node('/root/World/WaterPlane')

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

var acceleration = 0.05
var max_speed = 3.09 #Aprox 6 kn
var velocity = Vector3.ZERO

const SPEED = 0.05
const STEER_ANGLE = 3


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
	
	if Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_down"):	
		velocity.z = 0.00
	elif Input.is_action_pressed("ui_up"):
		velocity.z = -SPEED
	elif Input.is_action_pressed("ui_down"):
		velocity.z = SPEED
	else:
		velocity.z = lerp(velocity.z, 0.0 ,0.05)
	
	if Input.is_action_pressed("ui_right") and Input.is_action_pressed("ui_left"):
		velocity.x = 0.00
	elif Input.is_action_pressed("ui_right"):
		rotation.y -= (deg_to_rad(STEER_ANGLE))
		velocity.x = SPEED
	elif Input.is_action_pressed("ui_left"):
		rotation.y += (deg_to_rad(STEER_ANGLE))
		velocity.x = -SPEED
	else:
		velocity.x = lerp(velocity.x, 0.0 ,0.05)
		
	
	move_and_collide(velocity)

	#Water affect
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
