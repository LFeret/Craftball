extends "res://addons/godot-openvr/scenes/ovr_controller.gd"

# leander stuff
const ball = preload("res://leander/ball/ball.res")
var player = null

func _ready():	
		
	connect("button_pressed", self, "button_pressed")
	connect("button_release", self, "button_released")

func button_pressed(button_index):
	# If the trigger is pressed...
	if button_index == 15:
		player = get_parent()
			# leander stuff: ball_creation Input
		var current_ball = ball.instance()
		current_ball.sleeping = true
		# Set Ball Position
		current_ball.translate(Vector3(0,2,0))
			
		player.set_ball_to_right_hand(current_ball)
		
func button_released(button_index):
	 # If the trigger button is released...
	if button_index == 15  and player.holds_ball():
		player.throw_current_ball()



