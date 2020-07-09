extends Spatial


# leander stuff
const ball = preload("res://leander/ball/ball.res")
var player = null
var current_ball

# Called when the node enters the scene tree for the first time.
func _ready():
	player = $player
	player.set_world(self)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta):
	
	# leander stuff: ball_creation Input
	if Input.is_action_just_pressed("create_ball")  == true:
		current_ball = ball.instance()
		current_ball.sleeping = true
		# Set Ball Position
		add_child(current_ball)
		player.set_current_ball(current_ball)
		current_ball.pick_up(player, player.get_right_controller())

	elif player.holds_ball() and not Input.is_action_pressed("create_ball") == true:
		current_ball.sleeping = false
		current_ball.let_go(Vector3(-5,-20,-5))
