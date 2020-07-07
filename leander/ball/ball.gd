extends RigidBody

export var bouncing_count:int
var current_bounc_count:int
var color = 'red'

# Set hold mode
export (bool) var press_to_hold = true
export (bool) var reset_transform_on_pickup = true
export  (int, FLAGS, "Layer 1", "Layer 2", "Layer 3", "Layer 4", "Layer 5", "Layer 6", "Layer 7", "Layer 8", "Layer 9", "Layer 10", "Layer 11", "Layer 12", "Layer 13", "Layer 14", "Layer 15", "Layer 16", "Layer 17", "Layer 18", "Layer 19", "Layer 20") var picked_up_layer = 0

# Remember some state so we can return to it when the user drops the object
onready var original_parent = get_parent()
onready var original_collision_mask = collision_mask
onready var original_collision_layer = collision_layer

# Who picked us up?
var picked_up_by = null
var by_controller : ARVRController = null
var closest_count = 0

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
		
		get_parent().add_child(current_explosion)
		
		if is_instance_valid(self):
			self.queue_free()

func get_type():
	return 'ball'

func _on_ball_body_exited(body):
	pass

# pick up logic
# have we been picked up?
func is_picked_up():
	if picked_up_by:
		return true
	
	return false

func _update_highlight():
	# should probably implement this in our subclass
	pass

func increase_is_closest():
	closest_count += 1
	_update_highlight()

func decrease_is_closest():
	closest_count -= 1
	_update_highlight()

func drop_and_free():
	if picked_up_by:
		picked_up_by.drop_object()
	
	queue_free()

# we are being picked up by...
func pick_up(by, with_controller):
	if picked_up_by == by:
		return
	
	if picked_up_by:
		let_go()
	
	# remember who picked us up
	picked_up_by = by
	by_controller = with_controller
	
	# turn off physics on our pickable object
	mode = RigidBody.MODE_STATIC
	collision_layer = 0#picked_up_layer
	collision_mask = 0
	
	# now reparent it
	var original_transform = global_transform
	original_parent.remove_child(self)
	picked_up_by.add_child(self)
	
	if reset_transform_on_pickup:
		# reset our transform
		transform = Transform()
	else:
		# make sure we keep its original position
		global_transform = original_transform

# we are being let go
func let_go(starting_linear_velocity = Vector3(0.0, 0.0, 0.0)):
	if picked_up_by:
		# get our current global transform
		var t = global_transform
		
		# reparent it
		picked_up_by.remove_child(self)
		original_parent.add_child(self)
		
		# reposition it and apply impulse
		global_transform = t
		mode = RigidBody.MODE_RIGID
		collision_mask = original_collision_mask
		collision_layer = original_collision_layer
		
		# set our starting velocity
		linear_velocity = starting_linear_velocity
		
#		apply_impulse(Vector3(0.0, 0.0, 0.0), impulse)
		
		# we are no longer picked up
		picked_up_by = null
		by_controller = null
