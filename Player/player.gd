extends ARVROrigin

var current_ball = null
var world = null

export var impulse_factor = 1.0

export var max_samples = 5

var last_position = Vector3(0.0, 0.0, 0.0)
var velocities = Array()

# Called when the node enters the scene tree for the first time.
func _ready():
	var arvr_interface = ARVRServer.find_interface("OpenVR")
	if(arvr_interface and arvr_interface.initialize()):
		get_viewport().arvr = true
		get_viewport().hdr = false
		
	last_position = global_transform.origin

# leander stuff
func set_world(current_world):
	world = current_world

func holds_ball():
	if is_instance_valid(current_ball):
		if current_ball == null:
			return false
		else:
			return true
	else:
		current_ball = null
		return false

func get_right_controller():
	return $RightHand

func set_current_ball(ball):
	current_ball = ball
