extends "res://addons/godot-openvr/scenes/ovr_controller.gd"

const CONTROLLER_DEADZONE = 0.65

const MOVEMENT_SPEED = 2

var directional_movement = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func _process(delta):
# Directional movement
	# --------------------
		# NOTE: you may need to change this depending on which VR controllers
		# you are using and which OS you are on.
	var trackpad_vector = Vector2(-get_joystick_axis(1), get_joystick_axis(0))
	var joystick_vector = Vector2(-get_joystick_axis(5), get_joystick_axis(4))
	
	if trackpad_vector.length() < CONTROLLER_DEADZONE:
		trackpad_vector = Vector2(0, 0)
	else:
		 trackpad_vector = trackpad_vector.normalized() * ((trackpad_vector.length() - CONTROLLER_DEADZONE) / (1 - CONTROLLER_DEADZONE))

	if joystick_vector.length() < CONTROLLER_DEADZONE:
		joystick_vector = Vector2(0, 0)
	else:
		joystick_vector = joystick_vector.normalized() * ((joystick_vector.length() - CONTROLLER_DEADZONE) / (1 - CONTROLLER_DEADZONE))

	var forward_direction = get_parent().get_node("ARVRCamera").global_transform.basis.z.normalized()
	var right_direction = get_parent().get_node("ARVRCamera").global_transform.basis.x.normalized()
	
	var movement_vector = (trackpad_vector + joystick_vector).normalized()
	
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
