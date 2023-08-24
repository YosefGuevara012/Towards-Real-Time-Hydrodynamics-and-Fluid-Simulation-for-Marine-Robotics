extends Camera3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#func _physics_process(delta):
#
#	# Vehicle control function
#	get_input(delta)
#	move_and_collide(velocity)	
#
#	# Bouyancty effect
#	submerged = false
#	for p in probes:
#		var depth = water.get_height(p.global_position) - p.global_position.y 
#		if depth > 0:
#			submerged = true
#			apply_force(Vector3.UP * float_force * gravity * depth, p.global_position - global_position)
#
#func get_input(delta):
#
#	var velocity_y = velocity.y
#	velocity = Vector3.ZERO
#
#	if Input.is_action_pressed("ACCELERATE"):
#		velocity -=transform.basis.z * MAX_SPEED * delta
#	elif Input.is_action_pressed("REVERSE"):
#		velocity += transform.basis.z * MAX_SPEED * delta
#
#	if Input.is_action_pressed("RIGHT"):
#		rotate_y(-ANGULAR_SPEED * delta)
#	elif Input.is_action_pressed("LEFT"):	
#		rotate_y(ANGULAR_SPEED * delta)
#
#
#
#	velocity.y = velocity_y
