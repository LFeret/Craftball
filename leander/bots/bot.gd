extends KinematicBody


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

var rng

var time = 0
var timerVar = 0

func get_type():
	return 'bot'

# Called when the node enters the scene tree for the first time.
func _ready():
	rng = RandomNumberGenerator.new()
	move(walking_direction)

func _process(delta):
	timerVar += delta
	
	if timerVar >= 1:
		# ~ 1 Second gone
		time += 1
		timerVar = 0
		
		if time % throw_intervall == 0:
			throw_ball()
			time = 0

func move(direction):
	var collision = move_and_collide(direction * walking_speed)
	
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

func set_throw_direction():
	self.throw_direction = Vector3(0, -10, 0)

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
	force = throw_direction
	
	var t = global_transform

	global_transform = t
	collision_mask = 1
	collision_layer = 1
	
	var bot_position = self.get_global_transform().origin
	current_ball.translate(Vector3(bot_position.x, bot_position.y - 2, bot_position.z))
	
	# set our starting velocity
	current_ball.linear_velocity = force * 10 * rng.randi_range(1, 10)
	
	get_parent().add_child(current_ball) # add to World
	
	#apply_impulse(Vector3(0.0, 0.0, 0.0), impulse)

func get_linear_velocity():
	if past_position != null and current_position != null:
		return (current_position.origin - past_position.origin) / 0.0166 # 0.0166 --> framerate (time-delta)
	else:
		return Vector3(0,0,0)

func _on_bot_body_entered(body):
	walking_direction = -walking_direction
	pass # Replace with function body.

remote func pick_up_booster(booster_type):
	match booster_type:
		'speed_ball':
			set_ball_type('speed_ball')
		'block_ball':
			set_ball_type('block_ball')

remote func set_ball_type(ball_type):	
	ball_type = ball_type
