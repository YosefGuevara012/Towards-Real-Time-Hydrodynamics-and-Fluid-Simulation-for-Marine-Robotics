extends RayCast3D


var depth = 0
var measured_distance = 0
var vehicle_altitude = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	vehicle_altitude = self.global_transform.origin.y
	measured_distance = get_collision_point().y
	depth = snapped(abs(measured_distance - vehicle_altitude),0.01)
	print(depth)
