extends Spatial


# leander stuff
const ball = preload("res://leander/ball/ball.res")
var player = null

# Called when the node enters the scene tree for the first time.
func _ready():
	player = $player
	player.set_world(self)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
"""
func _process(delta):
	
	# leander stuff: ball_creation Input
	if Input.is_action_just_pressed("create_ball")  == true:
		var current_ball = ball.instance()
		current_ball.sleeping = true
		# Set Ball Position
		current_ball.translate(Vector3(0,2,0))
		
		player.set_ball_to_right_hand(current_ball)

	elif player.holds_ball() and not Input.is_action_pressed("create_ball") == true:
		player.throw_current_ball()
"""
