extends RigidBody3D

@export var float_force := 1.0
@export var water_drag := 0.05
@export var water_angular_drag := 0.05

@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var water = get_node('/root/World/WaterPlane')


#------------USING A RIDIG BODY INSTEAD A VEHICLE NODE

var acceleration = 0.05
var max_speed = 3.09 #Aprox 6 kn
var velocity = Vector3.ZERO

const SPEED = 0.05
const ROTATION_SPEED = 0.5

var submerged := false

const water_height := 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	
	############################
	get_input(delta)
	move_and_collide(velocity)	
	##############################
	
	submerged = false
	var depth = water.get_height(global_position) - global_position.y

	if depth > 0:
		submerged = true
		apply_central_force(Vector3.UP * float_force * gravity * depth)

func _integrate_forces(state:PhysicsDirectBodyState3D):
	
	if submerged:
		state.linear_velocity *= 1 - water_drag
		state.angular_velocity *= 1 - water_angular_drag
		
func get_input(delta):
	
	var vy = velocity.y
	velocity = Vector3.ZERO
	
	if Input.is_action_pressed("ui_up"):
		velocity += transform.basis.z * SPEED
	if Input.is_action_pressed("ui_down"):
		velocity -= transform.basis.z * SPEED
	if Input.is_action_pressed("ui_right"):
		rotate_y(-ROTATION_SPEED * delta)
	if Input.is_action_pressed("ui_left"):	
		rotate_y(ROTATION_SPEED * delta)
	
	velocity.y = vy
