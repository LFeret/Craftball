extends KinematicBody

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
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

func hit():
	self.get_parent().hit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
# Tamer stuff
func _physics_process(delta):
	pass


func pick_up_booster(booster_type):
	if booster_type == 'speed_ball':
		player.set_ball_type('speed_ball')
