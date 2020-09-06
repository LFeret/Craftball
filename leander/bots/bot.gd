extends RigidBody


var id
var color
var life = 5
var current_ball
var ball_type = 'normal_ball'

const ball = preload("res://leander/ball/ball.res")
const speed_ball = preload("res://leander/ball/speed_ball.res")
const block_ball = preload("res://leander/ball/block_ball.res")

var past_position = null
var current_position = null

var walking_direction = Vector3(1,0,1)
var walking_speed = 25

var throw_direction = Vector3(0,0,0)

var throw_intervall = 5

var time = 0
var timerVar = 0

func get_type():
	return 'bot'

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):
	timerVar += delta
	
	if timerVar >= 1:
		# ~ 1 Second gone
		time += 1
		timerVar = 0
		
		if time % throw_intervall == 0:
			throw_ball()
			time = 0
	
	# position logging - for throwing // leander stuff
	if past_position == null:
		past_position = global_transform # controler right now
	elif current_position == null:
		current_position = global_transform # controler right now
	else:
		past_position = current_position
		current_position = global_transform # controler right now

	set_linear_velocity(walking_direction * walking_speed * delta)

func set_player_pos(player_pos):
	walking_direction = player_pos
	throw_direction = player_pos
	
func set_color(set_color) -> void:
	color = set_color
	var material = SpatialMaterial.new()
	#var material = $MeshInstance.get_surface_material(0)
	
	match color:
		'red':
			material.albedo_color = Color(1,0,0)
		'blue':
			material.albedo_color = Color(0,0,1)
		'green':
			material.albedo_color = Color(0,1,0)
		'yellow':
			material.albedo_color = Color(1,1,0)
		'white':
			material.albedo_color = Color(1,1,1)
		'black':
			material.albedo_color = Color(0,0,0)
	
	get_child(0).set_surface_material(0, material)

func set_walking_direction(direction):
	match direction:
		'left':
			pass
		'right':
			pass
		
func set_walking_speed(speed):
	self.walking_speed = speed

func set_throw_direction(direction):
	self.throw_direction = direction

func hit():
	life -= 1
	if life <= 0:
		self.die()

func die():
	self.queue_free()
	print("Bot Died. Grats")

func throw_ball():
	match ball_type:
		'normal_ball':
			current_ball = ball.instance()
		'speed_ball':
			current_ball = speed_ball.instance()
		'block_ball':
			current_ball = block_ball.instance()

	current_ball.color = color
	current_ball.is_bot_ball = true

	current_ball.thrown = true
	current_ball.current_player = self
	
	var force = null
	# errechne Richtungs und Kraft Vector
	if throw_direction == Vector3(0,0,0):
		force = get_linear_velocity()
	else:
		force = throw_direction
	
	var t = global_transform

	global_transform = t
	mode = RigidBody.MODE_RIGID
	collision_mask = 1
	collision_layer = 1
	
	var bot_position = self.get_global_transform().origin
	current_ball.translate(bot_position)
	
	# set our starting velocity
	linear_velocity = force * 100
	
	get_parent().add_child(current_ball) # add to World
	
	#apply_impulse(Vector3(0.0, 0.0, 0.0), impulse)

func get_linear_velocity():
	if past_position != null and current_position != null:
		return (current_position.origin - past_position.origin) / 0.0166 # 0.0166 --> framerate (time-delta)
	else:
		return Vector3(0,0,0)
