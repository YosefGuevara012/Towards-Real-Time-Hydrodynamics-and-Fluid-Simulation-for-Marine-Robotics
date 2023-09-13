extends ColorRect

@onready var water = get_node('/root/World/WaterPlane')
# Called when the node enters the scene tree for the first time.




func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(_delta):
	change_ocean_color()
	change_wind_speed()
	change_wave_height()
	change_wind_direction()

func change_wind_speed():
	
	var wave_speed: int = $slider_wind_speed.value
	water.material.set_shader_parameter("wave_speed", wave_speed)

func change_wave_height():
	
	var wave_height: float = $slider_wave_amplitude.value / 100
	water.material.set_shader_parameter("height_scale", wave_height)

func change_wind_direction():
	var wave_direction = water.material.get_shader_parameter("wave_direction")
	var wave_2_direction = water.material.get_shader_parameter("wave_2_direction")
	var wind_direction: int = $slider_wind_direction.value
	
	water.material.set_shader_parameter("wave_direction", wave_direction + Vector2(wind_direction,wind_direction))
	water.material.set_shader_parameter("wave_2_direction", wave_2_direction + Vector2(wind_direction,wind_direction))
	print(water.material.get_shader_parameter("wave_direction"))

func change_ocean_color():
	
	var color_selector: int = $slider_ocean_color.value
	var ocean_color = 0x001820
	
	match color_selector:
		1: 
				ocean_color  = 0x001820
		2:
				ocean_color  = 0x003e51
		3: 
				ocean_color  = 0x16c7ff
		4: 
				ocean_color  = 0x78deff
		5: 
				ocean_color  = 0xdaf6fe
	
	water.material.set_shader_parameter("albedo",Color(ocean_color))	
	
	#water.material.set_shader_parameter("wave_speed",22)
	#print(water.material.get_shader_parameter("wave_speed"))
