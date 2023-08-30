extends RayCast3D


var depth = 0
var measured_distance = 0
var vehicle_altitude = 0

signal measured_depth(new_depth: float)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	vehicle_altitude = self.global_transform.origin.y
	measured_distance = get_collision_point().y
	depth = snapped(abs(measured_distance - vehicle_altitude),0.01)
	emit_signal("measured_depth", depth)
