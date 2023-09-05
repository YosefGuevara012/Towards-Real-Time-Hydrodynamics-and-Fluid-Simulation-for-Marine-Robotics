extends RigidBody3D

@export var water_drag := 0.05
@export var water_angular_drag := 0.05

# Wind variables:
@export var wind_speed := 30
@export var wind_direction := 0.05

# Global Physics varibles
@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var water = get_node('/root/World/WaterPlane')

# Bouyancy variables
@export_range(1020, 1029) var surface_seawater_density : int =  1020
@export var object_total_volume  = 0.004 # The total volume of the object in m^3
@export_range(0, 1) var submerged_fraction : float =  0.85
@onready var probes = $ProbeContainer.get_children()
var submerged := false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(_delta):
	
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

func _integrate_forces(state:PhysicsDirectBodyState3D):
	
	if submerged:
		state.linear_velocity *= 1 - water_drag
		state.angular_velocity *= 1 - water_angular_drag
