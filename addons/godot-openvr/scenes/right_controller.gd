extends "res://addons/godot-openvr/scenes/ovr_controller.gd"

# leander stuff
const ball = preload("res://leander/ball/ball.res")
const speed_ball = preload("res://leander/ball/speed_ball.res")
const timer = preload("res://leander/gui/timer_display.tscn")
const cube = preload("res://myObjects/Cube/Cube.tscn")
const ramp = preload("res://myObjects/Cube/Ramp.tscn")
#const cube = null
var player = null
var current_ball = null
var networking = null
var past_position = null
var current_position = null
var current_cube = null
var current_timer = null

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
		if button_index == 14:
			rpc_unreliable("create_cube", player.player_id)
			create_cube(player.player_id)
			
		
func button_released(button_index):
	 # If the trigger button is released...
	if get_parent().control:
		if button_index == 15  and player.holds_ball():
			#player.throw_current_ball()
			
			# TODO: use rpc_unreliable("create_ball") # maybe player_id is necessesary to give
			rpc_unreliable("throw_ball", player.player_id)
			throw_ball(player.player_id)
		if button_index == 14: #and holds_cube()
			rpc_unreliable("let_go_cube", player.player_id)
			let_go_cube(player.player_id)
		
remote func create_ball(id):
	var curr_player = networking.players[id]
	
	match curr_player.current_ball_type:
		'normal_ball':
			curr_player.current_ball = ball.instance()
		'speed_ball':
			curr_player.current_ball = speed_ball.instance()
	
	# maybe get node by player_id is necesseray
	
	curr_player.current_ball.sleeping = true
	# Set Ball Position
	curr_player.get_parent().add_child(current_ball)
	curr_player.current_ball.pick_up(self, self)

remote func throw_ball(id):
	var curr_player = networking.players[id]
	curr_player.current_ball.sleeping = false
	curr_player.current_ball.thrown = true
	curr_player.current_ball.current_player = curr_player
	
	# errechne Richtungs und Kraft Vector
	var force = get_linear_velocity()
	
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

func setup_timer(time_in_seconds, type):
	current_timer = timer.instance()
	current_timer.setup_timer(time_in_seconds, type, player)
	if self.get_child_count() <= 3:
		self.add_child(current_timer)

remote func create_cube(id):
	var curr_player = networking.players[id]
	
	var trackpad_vector = Vector2(-get_joystick_axis(1), get_joystick_axis(0))
	print(trackpad_vector)	
	
	# Würfel oder Rape erzeugen
	curr_player.current_cube = cube.instance()
	if -get_joystick_axis(1) <= 0 and get_joystick_axis(0) >= 0:
		curr_player.current_cube = ramp.instance()
	elif -get_joystick_axis(1) >= 0 and get_joystick_axis(0) <= 0:
		curr_player.current_cube = cube.instance()
	
	curr_player.current_cube.sleeping = true
	#  Cube Position
	curr_player.get_parent().add_child(current_cube)
	curr_player.current_cube.pick_up(self, self)
	
remote func let_go_cube(id):
	var curr_player = networking.players[id]
	curr_player.current_cube.sleeping = false
	curr_player.current_cube.thrown = true
	
	# errechne Richtungs und Kraft Vector
	var force = get_linear_velocity()
	curr_player.current_cube.let_go(force)
	
func holds_cube():
	if is_instance_valid(current_cube):
		if current_cube == null:
			return false
		else:
			return true
	else:
		current_cube = null
		return false

func get_linear_velocity():
	if past_position != null and current_position != null:
		return (current_position.origin - past_position.origin) / 0.0166 # 0.0166 --> framerate (time-delta)
		
		"""
		# posible necessery to normalize part and curr position with .normalized()
		var past_vector = past_position.origin
		var curr_vector = current_position.origin
		
		var direction = get_direction(past_vector, curr_vector)
		var force = Vector3(
			get_force(past_vector.x, curr_vector.x, 10000),
			get_force(past_vector.y, curr_vector.y, 100),
			get_force(past_vector.z, curr_vector.z, 10000)
		)
		print(direction)
		print(force)
		return Vector3(direction.x * force.x, direction.y * force.y, direction.z * force.z) # sowas in der Art
		"""
	else:
		return Vector3(0,0,0)

func get_direction(past_position, current_position):
	return ((past_position.normalized() + current_position.normalized()) * 0.5).normalized()

func get_force(point1, point2, force_offset=1000):
	var force = 0
	
	if point1 <= point2:
		force = abs(point2)-abs(point1)
	else:
		force = abs(point2)-abs(point1)
	
	return force * force_offset
	
