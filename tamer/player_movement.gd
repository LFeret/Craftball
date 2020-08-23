extends KinematicBody

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 100
var location = Vector3()
var gravity = -10
var velocity = Vector3()

var player


# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent()
	pass # Replace with function body.

func get_type():
	return 'Player'

# Called every frame. 'delta' is the elapsed time since the previous frame.
# Tamer stuff
func _physics_process(delta):
	pass
####NEW STUFF
#
#	var left_analog_axis = Vector2(Input.get_joy_axis(0, JOY_AXIS_0)*7, Input.get_joy_axis(0, JOY_AXIS_1)*-7)
#
#	set_rotation(Vector3(0, left_analog_axis.angle(), 0))	
#
#	if left_analog_axis.length() > 0.25:
#		move_and_slide(Vector3(left_analog_axis.x, 0, left_analog_axis.y))	
#
#
#
######OLD 	
#	location = Vector3(0,0,0)
#	if Input.is_action_just_pressed("ui_left"):
#		print("left click")
#		location.x -= 1
#	if Input.is_action_just_pressed("ui_right"):
#		print("right click")
#		location.x += 1
#	if Input.is_action_just_pressed("ui_up"):
#		print("up click")
#		location.z -= 1
#	if Input.is_action_just_pressed("ui_down"):
#		print("down click")
#		location.z += 1
#	location = location.normalized()
#	location = location*speed*delta
#
#	velocity.y += gravity*delta
#	velocity.x = location.x
#	velocity.z = location.z
#
#	velocity = move_and_slide(velocity, Vector3 (0,1,0))
#
#	if is_on_floor() and Input.is_key_pressed(KEY_SPACE):
#		velocity.y = 4


func pick_up_booster(booster_type):
	if booster_type == 'speed_ball':
		player.set_ball_type('speed_ball')
