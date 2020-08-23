extends "res://leander/ball/ball.gd"

const cube_script = preload("res://myObjects/Cube/Cube.tscn")

func _ready():
	bouncing_count = 3

func _on_speed_ball_body_entered(body):
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
	
	# Bouncing Stuff
	current_bounc_count += 1
	
	# TODO: Create Cube!
	var curr_cube = cube_script.instance()
	var localTranslate = Vector3(0,0,2)
	curr_cube.translate(curr_cube.get_transform().basis.xform(localTranslate))
	# curr_cube.translate(localTranslate)
	get_parent().add_child(curr_cube)
	
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

func _on_speed_ball_body_exited(body):
	
	pass # Replace with function body.
