extends RigidBody3D

@export var float_force := 1.0
@export var water_drag := 0.05
@export var water_angular_drag := 0.05

@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var water = get_node('/root/World/WaterPlane')

@onready var probes = $ProbeContainer.get_children()


#------------USING A RIDIG BODY INSTEAD A VEHICLE NODE

var max_speed = 3.09 #Aprox 6 kn
var SPEED = 0.05
const ANGULAR_SPEED = 0.5

#----------Vehicle Varibales

@export var engine_force = 5.80
var velocity = Vector3.ZERO

# Water Effect varibles
var submerged := false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	
	# Vehicle control function
	get_input(delta)
	move_and_collide(velocity)	
	
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
	velocity = Vector3.ZERO
	
	if Input.is_action_pressed("ACCELERATE"):
		velocity -=transform.basis.z * SPEED
	elif Input.is_action_pressed("REVERSE"):
		velocity += transform.basis.z * SPEED
	
	if Input.is_action_pressed("RIGHT"):
		rotate_y(-ANGULAR_SPEED * delta)
	elif Input.is_action_pressed("LEFT"):	
		rotate_y(ANGULAR_SPEED * delta)

	

	velocity.y = velocity_y
