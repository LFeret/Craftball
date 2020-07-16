extends "res://addons/godot-openvr/scenes/ovr_controller.gd"

# leander stuff
const ball = preload("res://leander/ball/ball.res")
var player = null
var current_ball = null
var networking = null
var past_position = null
var current_position = null

func _process(delta):
	# position logging - for throwing // leander stuff
	if past_position == null:
		past_position = global_transform # controler right now
	elif current_position == null:
		current_position = global_transform # controler right now
	else:
		past_position = current_position
		current_position = global_transform # controler right now
	
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
		
func button_released(button_index):
	 # If the trigger button is released...
	if get_parent().control:
		if button_index == 15  and player.holds_ball():
			#player.throw_current_ball()
			
			# TODO: use rpc_unreliable("create_ball") # maybe player_id is necessesary to give
			rpc_unreliable("throw_ball", player.player_id)
			throw_ball(player.player_id)
		
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
	curr_player.current_ball.thrown = true
	
	# errechne Richtungs und Kraft Vector
	var force = getThrowingForce()
	
	curr_player.current_ball.let_go(force)

func holds_ball():
	if is_instance_valid(current_ball):
		if current_ball == null:
			return false
		else:
			return true
	else:
		current_ball = null
		return false

func getThrowingForce():
	if past_position != null and current_position != null:
		# posible necessery to normalize part and curr position with .normalized()
		var force = (past_position.origin + current_position.origin) * 0.5
		force.x = force.x * 10
		force.y = force.y * 2
		force.z = force.z * 10
		
		return force
	else:
		return Vector3(0,0,0)
