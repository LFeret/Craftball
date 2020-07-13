extends ARVROrigin

var player_name
var player_id
var control = false
var networking

var current_ball = null
const ball = preload("res://leander/ball/ball.res")

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



func get_right_controller():
	return $RightHand
