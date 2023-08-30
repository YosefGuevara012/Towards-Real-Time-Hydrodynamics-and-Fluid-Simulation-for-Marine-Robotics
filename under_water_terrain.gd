@tool
extends MeshInstance3D

@export var x_size = 20
@export var z_size = 20

@export var update = false
@export var clear_vert_vis = false

# Called when the node enters the scene tree for the first time.
func _ready():
	generate_terrain()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func generate_terrain():
	var array_mesh: ArrayMesh
	var surftool = SurfaceTool.new()
	
	var noise =  FastNoiseLite.new()
	noise.noise_type  = FastNoiseLite.TYPE_PERLIN
	noise.frequency = 0.1
	
	
	surftool.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	for z in range(z_size + 1):
		for x in range(x_size + 1):
			var y = noise.get_noise_2d(x * 0.5, z * 0.5 ) * 5
			
			surftool.add_vertex(Vector3(x,y,z))
			# draw_sphere(Vector3(x,y,z))
	
	var vert_index = 0
	for z in z_size:
		for x in x_size:
			surftool.add_index(vert_index + 0)
			surftool.add_index(vert_index + 1)
			surftool.add_index(vert_index + x_size + 1)
			surftool.add_index(vert_index + x_size + 1)
			surftool.add_index(vert_index + 1)
			surftool.add_index(vert_index + x_size + 2)
			vert_index += 1
			
		vert_index += 1
	
	surftool.generate_normals()
	array_mesh = surftool.commit()
	
	mesh = array_mesh
	
	
# uncomment to check the position of each vertex
#func draw_sphere(pos:Vector3):
#
#	var mesh_instance = MeshInstance3D.new()
#	add_child(mesh_instance)
#
#	mesh_instance.position = pos
#	var sphere = SphereMesh.new()
#	sphere.radius = 0.1
#	sphere.height = 0.2
#	mesh_instance.mesh = sphere

func _process(_delta):
	if update:
		generate_terrain()
		update = false
	
	if clear_vert_vis:
		for i in get_children():
			i.free()
