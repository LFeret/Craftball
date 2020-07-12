extends "res://addons/godot-openvr/scenes/ovr_controller.gd"

# leander stuff
const ball = preload("res://leander/ball/ball.res")
var player = null

const cube = preload("res://myObjects/Cube.tscn")

func _ready():	
		
	connect("button_pressed", self, "button_pressed")
	connect("button_release", self, "button_released")

func button_pressed(button_index):
	player = get_parent()
	# If the trigger is pressed...
	if button_index == 15:		
			# leander stuff: ball_creation Input
		var current_ball = ball.instance()
		current_ball.sleeping = true
		# Set Ball Position
		current_ball.translate(Vector3(0,2,0))
			
		player.set_ball_to_right_hand(current_ball)
		
	if button_index == 14:
		var current_cube = cube.instance()
		current_cube.sleeping = true
		# Set Ball Position
		current_cube.translate(Vector3(0,2,0))
			
		player.set_cube_to_right_hand(current_cube)
		
		
func button_released(button_index):
	 # If the trigger button is released...
	if button_index == 15  and player.holds_ball():
		player.throw_current_ball()
		
	if button_index == 14 and player.holds_cube():
		player.place_current_cube()



