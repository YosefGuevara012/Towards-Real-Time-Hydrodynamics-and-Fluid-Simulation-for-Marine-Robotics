extends Control

@onready var environmental_variables = $Environmental_variables

var active_hud = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	environmental_variables.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func switch_camera():
	
	active_hud += 1
	if active_hud == 1:
		environmental_variables.visible = false
	elif active_hud == 2:
		environmental_variables.visible = true
		active_hud = 0
	
		

func get_input(delta):
	
	if Input.is_action_just_pressed("ENVIRONMENT_VARIABLES"):
		switch_camera()

		
	
func _physics_process(delta):
	get_input(delta)
