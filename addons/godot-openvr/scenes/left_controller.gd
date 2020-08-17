extends "res://addons/godot-openvr/scenes/ovr_controller.gd"

const CONTROLLER_DEADZONE = 0.65

const MOVEMENT_SPEED = 2

enum MOVEMENT_TYPE { MOVE_AND_ROTATE, MOVE_AND_STRAFE }

# to combat motion sickness we'll 'step' our left/right turning
export var smooth_rotation = false
export var smooth_turn_speed = 2.0
export var step_turn_delay = 0.2
export var step_turn_angle = 20.0

var turn_step = 0.0
var origin_node = null
var camera_node = null
var velocity = Vector3(0.0, 0.0, 0.0)
var gravity = -30.0

export (MOVEMENT_TYPE) var move_type = MOVEMENT_TYPE.MOVE_AND_ROTATE

var directional_movement = false
# Called when the node enters the scene tree for the first time.
func _ready():
	origin_node = get_node("..")
	camera_node = get_parent().get_node("ARVRCamera")
	
func _process(delta):
	#TODO Umschauen geht nur die Richtung vom laufen ist noch nicht richtig
# Directional movement
	# --------------------
		# NOTE: you may need to change this depending on which VR controllers
		# you are using and which OS you are on.
#	var trackpad_vector = Vector2(-get_joystick_axis(1), get_joystick_axis(0))
	var joystick_vector = Vector2(-get_joystick_axis(5), get_joystick_axis(4))
	
#	if trackpad_vector.length() < CONTROLLER_DEADZONE:
#		trackpad_vector = Vector2(0, 0)
#	else:
#		 trackpad_vector = trackpad_vector.normalized() * ((trackpad_vector.length() - CONTROLLER_DEADZONE) / (1 - CONTROLLER_DEADZONE))

	if joystick_vector.length() < CONTROLLER_DEADZONE:
		joystick_vector = Vector2(0, 0)
	else:
		joystick_vector = joystick_vector.normalized() * ((joystick_vector.length() - CONTROLLER_DEADZONE) / (1 - CONTROLLER_DEADZONE))

	var forward_direction = get_parent().get_node("ARVRCamera").global_transform.basis.z.normalized()
	var right_direction = get_parent().get_node("ARVRCamera").global_transform.basis.x.normalized()
	
	#var movement_vector = (trackpad_vector + joystick_vector).normalized()
	var movement_vector = (joystick_vector).normalized()
	
	var movement_forward = forward_direction * movement_vector.x * delta * MOVEMENT_SPEED
	var movement_right = right_direction * movement_vector.y * delta * MOVEMENT_SPEED
	
	movement_forward.y = 0
	movement_right.y = 0
	
	if movement_right.length() > 0 or movement_forward.length() > 0:
		get_parent().translate(movement_right + movement_forward)
		directional_movement = true
	else:
		directional_movement = false
# --------------------	
	var left_right = -get_joystick_axis(0)
	var forwards_backwards = -get_joystick_axis(1)
	if(move_type == MOVEMENT_TYPE.MOVE_AND_ROTATE && abs(left_right) > 0.1):
		if smooth_rotation:
			# we rotate around our Camera, but we adjust our origin, so we need a little bit of trickery
			var t1 = Transform()
			var t2 = Transform()
			var rot = Transform()
			
			t1.origin = -camera_node.transform.origin
			t2.origin = camera_node.transform.origin
			rot = rot.rotated(Vector3(0.0, -1.0, 0.0), smooth_turn_speed * delta * left_right)
			origin_node.transform *= t2 * rot * t1
			
			# reset turn step, doesn't apply
			turn_step = 0.0
		else:
			if left_right > 0.0:
				if turn_step < 0.0:
					# reset step
					turn_step = 0
				
				turn_step += left_right * delta
			else:
				if turn_step > 0.0:
					# reset step
					turn_step = 0
				
				turn_step += left_right * delta
			
			if abs(turn_step) > step_turn_delay:
				# we rotate around our Camera, but we adjust our origin, so we need a little bit of trickery
				var t1 = Transform()
				var t2 = Transform()
				var rot = Transform()
				
				t1.origin = -camera_node.transform.origin
				t2.origin = camera_node.transform.origin
				
				# Rotating
				while abs(turn_step) > step_turn_delay:
					if (turn_step > 0.0):
						rot = rot.rotated(Vector3(0.0, -1.0, 0.0), step_turn_angle * PI / 180.0)
						turn_step -= step_turn_delay
					else:
						rot = rot.rotated(Vector3(0.0, 1.0, 0.0), step_turn_angle * PI / 180.0)
						turn_step += step_turn_delay
				
				origin_node.transform *= t2 * rot * t1
	else:
		# reset turn step, no longer turning
		turn_step = 0.0
