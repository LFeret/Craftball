extends RigidBody

export var bouncing_count:int
var current_bounc_count:int
var color = 'red'

func _ready():
  current_bounc_count = 0

func _on_ball_body_entered(body):
	print("Body Entered Ball")
	
	# Painting Floor Stuff
	if body.get_type() == 'HexTile':
		body.paint_self(color)
	
	# Bouncing Stuff
	current_bounc_count += 1
	
	if current_bounc_count >= bouncing_count:
		if is_instance_valid(self):
			self.queue_free()
	


func _on_ball_body_exited(body):
	print("Body Exited Ball")
