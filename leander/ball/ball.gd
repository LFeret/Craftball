extends "res://leander/ball/ball_pickable.gd"

export var bouncing_count:int
var current_bounc_count:int
var color = 'red'

var explosion
var bouncing_sound = null

func _ready():
	current_bounc_count = 0
	explosion = preload('res://leander/explosions/explosion.tscn')
	bouncing_sound = preload("res://leander/ball/bounce_sound.ogg")
	get_node("audio").stream = bouncing_sound

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
	else:
		# play bounce sound
		get_node("audio").stop()
		get_node("audio").play(0)

func get_type():
	return 'ball'

func _on_ball_body_exited(body):
	pass
