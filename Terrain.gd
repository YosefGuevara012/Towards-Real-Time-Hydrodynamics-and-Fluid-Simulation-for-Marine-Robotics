extends StaticBody3D


@export var generate_mesh: bool setget set_generate_mesh

# Called when the node enters the scene tree for the first time.

func setget_generate_mesh(bool) -> void:
	print("Generating Mesh...")
	var plane_mesh = PlaneMesh.new()
	
	plane_mesh.size = Vector2(4,4)
	plane_mesh.subdivide_depth = 3
	plane_mesh.subdivide_width = 3
	
	
