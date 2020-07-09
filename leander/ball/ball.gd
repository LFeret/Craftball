extends "res://addons/godot-xr-tools/objects/Object_pickable.gd"

export var bouncing_count:int
var current_bounc_count:int
var color = 'red'

var explosion

func _ready():
  current_bounc_count = 0
  explosion = preload('res://leander/explosions/explosion.tscn')

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
		
		var current_explosion = explosion.instance()
		
		var ball_position = get_global_transform().origin
		current_explosion.translate(ball_position)
		
		get_parent().get_parent().add_child(current_explosion)
		
		if is_instance_valid(self):
			self.queue_free()

func get_type():
	return 'ball'

func _on_ball_body_exited(body):
	pass
