extends "res://leander/ball/ball.gd"

export var max_shots:int
var current_shot_count:int

var colorFirstShot = 'yellow'
var colorSecondShot = 'red'

func _ready():
	bouncing_count = 3

func _on_ball_body_entered(body):	
	# Painting Floor Stuff
	if body.get_type() == 'HexTile':
		body.paint_self(color)
	elif body.get_type() == 'ball':
		# TODO: Particle explosion!
		body.queue_free()
		self.queue_free()
	elif body.get_type() == 'Cube':
		body.count_hit()
	elif body.get_type() == 'booster':
		current_player.pick_up_booster(body.get_power_up())
		body.queue_free()
	elif body.get_type() == 'Player':
		body.hit()
	
	# Bouncing Stuff
	current_bounc_count += 1
	
	if current_bounc_count >= bouncing_count:
		
		var current_explosion = explosion.instance()
		
		var ball_position = get_global_transform().origin
		current_explosion.translate(ball_position)
		
		get_parent().get_parent().add_child(current_explosion)
		
		if is_instance_valid(self):
			self.queue_free()
	else:
		# play bounce sound
		get_node("audio").stop()
		get_node("audio").play(0)

func get_type():
	return 'ball'

func _on_ball_body_exited(body):
	pass
