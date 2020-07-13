extends "res://addons/godot-openvr/scenes/ovr_controller.gd"

# leander stuff
const ball = preload("res://leander/ball/ball.res")
var player = null
var current_ball = null
var networking = null

var cube = preload("res://myObjects/Cube.tscn")
var current_cube = null

func _ready():	
	networking = get_node("/root/global").networking #get_parent().get_child(get_parent().get_child_count()-2)
	player = get_parent()
	
	connect("button_pressed", self, "button_pressed")
	connect("button_release", self, "button_released")

func button_pressed(button_index):
	if get_parent().control:
		# If the trigger is pressed...
		if button_index == 15:
			"""
			player = get_parent()
				# leander stuff: ball_creation Input
			var current_ball = ball.instance()
			current_ball.sleeping = true
			# Set Ball Position
			current_ball.translate(Vector3(0,2,0))
				
			player.set_ball_to_right_hand(current_ball)
			"""
			# TODO: use rpc_unreliable("create_ball") # maybe player_id is necessesary to give
				
			rpc_unreliable("create_ball", player.player_id)
			create_ball(player.player_id)
			
		if button_index == 14:
			rpc_unreliable("create_cube", player.player_id)
			create_cube(player.player_id)
		
func button_released(button_index):
	 # If the trigger button is released...
	if get_parent().control:
		if button_index == 15:
			#player.throw_current_ball()
			
			# TODO: use rpc_unreliable("create_ball") # maybe player_id is necessesary to give
			rpc_unreliable("throw_ball", player.player_id)
			throw_ball(player.player_id)
			
		if button_index == 14:
			rpc_unreliable("let_go_cube", player.player_id)
			let_go_cube(player.player_id)
		
remote func create_ball(id):
	var curr_player = networking.players[id]
	
	# maybe get node by player_id is necesseray
	curr_player.current_ball = ball.instance()
	curr_player.current_ball.sleeping = true
	# Set Ball Position
	curr_player.add_child(current_ball)
	curr_player.current_ball.pick_up(curr_player, self)


remote func throw_ball(id):
	var curr_player = networking.players[id]
	curr_player.current_ball.sleeping = false
	curr_player.current_ball.let_go(Vector3(-5,-20,-5))

func holds_ball():
	if is_instance_valid(current_ball):
		if current_ball == null:
			return false
		else:
			return true
	else:
		current_ball = null
		return false
		
		
remote func create_cube(id):
	var curr_player = networking.players[id]
		
	# maybe get node by player_id is necesseray
	curr_player.current_cube = cube.instance()
	curr_player.current_cube.sleeping = true
	#  Cube Position
	curr_player.add_child(current_cube)
	curr_player.current_cube.pick_up(curr_player, self)


remote func let_go_cube(id):
	var curr_player = networking.players[id]
	curr_player.current_cube.sleeping = false
	curr_player.current_cube.let_go(Vector3(-2,-4,-2))
	
	# let go of this object
	#picked_up_object.let_go(_get_velocity() * impulse_factor)

	
func holds_cube():
	if is_instance_valid(current_cube):
		if current_cube == null:
			return false
		else:
			return true
	else:
		current_cube = null
		return false

