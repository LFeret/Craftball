extends RigidBody

export var bouncing_count:int
var current_bounc_count:int
var color = 'red'

func _ready():
  current_bounc_count = 0

func _on_ball_body_entered(body):	
	# Painting Floor Stuff
	if body.get_type() == 'HexTile':
		body.paint_self(color)
	elif body.get_type() == 'ball':
		# TODO: Particle explosion!
		body.queue_free()
		self.queue_free()
	
	# Bouncing Stuff
	current_bounc_count += 1
	
	if current_bounc_count >= bouncing_count:
		if is_instance_valid(self):
			self.queue_free()

func get_type():
	return 'ball'

func _on_ball_body_exited(body):
	pass
