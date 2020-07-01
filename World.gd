extends Spatial


# leander stuff
var is_ball_in_hand = false
const ball = preload("res://leander/ball/ball.res")
var current_ball = null # TODO: Player has one Ball!

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	# leander stuff: ball_creation Input
	if Input.is_action_just_pressed("create_ball")  == true:
		is_ball_in_hand = true
		current_ball = ball.instance()
		current_ball.sleeping = true
		# Set Ball Position
		current_ball.translate(Vector3(3,5,3))
		
		add_child(current_ball)
		
		print("ball created")
	elif is_instance_valid(current_ball) and is_ball_in_hand and not Input.is_action_pressed("create_ball") == true:
		current_ball.sleeping = false
		is_ball_in_hand = false
		print("ball released")
