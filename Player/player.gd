extends ARVROrigin

var player_name
var player_id
var control = false
var networking

var current_ball = null
const ball = preload("res://leander/ball/ball.res")

export var impulse_factor = 1.0

export var max_samples = 5

var last_position = Vector3(0.0, 0.0, 0.0)
var velocities = Array()


# Called when the node enters the scene tree for the first time.
func _ready():
	networking = get_node("/root/global").networking #get_parent().get_child(get_parent().get_child_count()-2)
	var arvr_interface = ARVRServer.find_interface("OpenVR")
	if(arvr_interface and arvr_interface.initialize()):
		get_viewport().arvr = true
		get_viewport().hdr = false
		
	last_position = global_transform.origin

func set_name(name):
	# wird vom Multiplayer gestarted, sobald sich ein client verbindet!
	player_name = name


# leander stuff
func _process(delta):
	
	# leander stuff: ball_creation Input
	if control:
		if Input.is_action_just_pressed("create_ball")  == true:
			# TODO: use rpc_unreliable("create_ball") # maybe player_id is necessesary to give
			rpc_unreliable("create_ball", player_id)
			create_ball(player_id)
	
		elif holds_ball() and not Input.is_action_pressed("create_ball") == true:
			# TODO: use rpc_unreliable("create_ball") # maybe player_id is necessesary to give
			rpc_unreliable("throw_ball", player_id)
			throw_ball(player_id)

remote func create_ball(id):
	var curr_player = networking.players[id]
	
	# maybe get node by player_id is necesseray
	curr_player.current_ball = ball.instance()
	curr_player.current_ball.sleeping = true
	# Set Ball Position
	curr_player.get_parent().add_child(current_ball)
	curr_player.current_ball.pick_up(self, self)

remote func throw_ball(id):
	var curr_player = networking.players[id]
	curr_player.current_ball.sleeping = false
	curr_player.current_ball.let_go()

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
