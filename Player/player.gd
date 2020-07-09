extends ARVROrigin

var current_ball = null
var world = null
const ball = preload("res://leander/ball/ball.res")

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
func _process(delta):
	
	# leander stuff: ball_creation Input
	if Input.is_action_just_pressed("create_ball")  == true:
		current_ball = ball.instance()
		current_ball.sleeping = true
		# Set Ball Position
		add_child(current_ball)
		current_ball.pick_up(self, get_right_controller())

	elif holds_ball() and not Input.is_action_pressed("create_ball") == true:
		current_ball.sleeping = false
		current_ball.let_go(Vector3(-5,-20,-5))

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
