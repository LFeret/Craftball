extends ARVROrigin

var player_name
var player_id
var control = false
var networking
var color = ''

var current_ball_type = 'normal_ball'
var current_ball = null
const ball = preload("res://leander/ball/ball.res")
const speed_ball = preload("res://leander/ball/speed_ball.res")
export var life = 5

var current_cube = null

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

func hit():
	life -= 1
	if life <= 0:
		self.die()

func die():
	get_node("/root/global/").networking.player_died(player_id)
	self.queue_free()
	print("you diiiied!!!! Dont hit yourself xD")

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
	if curr_player.ball_type == 'speed_ball':
		curr_player.current_ball = speed_ball.instance()
	else:
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

remote func pick_up_booster(booster_type):
	match booster_type:
		'speed_ball':
			set_ball_type('speed_ball')
		'block_ball':
			set_ball_type('block_ball')

remote func set_ball_type(ball_type):
	var curr_player = networking.players[player_id]
	
	curr_player.current_ball_type = ball_type
	
	$RightHand.setup_timer(30, 'ball')

func get_right_controller():
	return $RightHand

func set_color(color) -> void:
	self.color = color
