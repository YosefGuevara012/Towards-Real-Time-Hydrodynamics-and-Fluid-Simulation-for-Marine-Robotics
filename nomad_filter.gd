extends RigidBody3D

@export var float_force: = 1.0
@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

const water_height := 0.0
# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	var depth = water_height - global_position.y

	if depth > 0:
		apply_central_force(Vector3.UP * float_force * gravity * depth)
