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

func set_ball_to_right_hand(ball):
	current_ball = ball
	
	# Add child to right controler
	$RightHand.add_child(current_ball)
	
	#add_child(current_ball)
	print("set ball to right hand picked up")

func throw_current_ball():
	current_ball.sleeping = false
	
	# let go of this object (geht nicht wwie geplant. -> pickable Object nutzen)
	#current_ball.let_go(_get_velocity() * impulse_factor)
	#current_ball = null
	
	# reparent to world
	var old_position = current_ball.get_global_transform().origin
	$RightHand.remove_child(current_ball)
	world.add_child(current_ball)
	current_ball.translate(old_position)
	
	# TODO: Add thrall
	current_ball.add_force(Vector3(-200,-200,-200), Vector3(0,0,0)) # force, position
	
	current_ball = null
	print("throw current ball TODO: Add physics")
	
func _get_velocity():
	var velocity = Vector3(0.0, 0.0, 0.0)
	var count = velocities.size()
	
	if count > 0:
		for v in velocities:
			velocity = velocity + v
		
		velocity = velocity / count
	
	return velocity
	
func _process(delta):
	velocities.push_back((global_transform.origin - last_position) / delta)
	if velocities.size() > max_samples:
		velocities.pop_front()
	
	last_position = global_transform.origin


