extends RigidBody

# Set hold mode
export (bool) var press_to_hold = true
export (bool) var reset_transform_on_pickup = true
export (NodePath) var center_pickup_on = null
export  (int, FLAGS, "Layer 1", "Layer 2", "Layer 3", "Layer 4", "Layer 5", "Layer 6", "Layer 7", "Layer 8", "Layer 9", "Layer 10", "Layer 11", "Layer 12", "Layer 13", "Layer 14", "Layer 15", "Layer 16", "Layer 17", "Layer 18", "Layer 19", "Layer 20") var picked_up_layer = 0

# Remember some state so we can return to it when the user drops the object
onready var original_parent = get_parent().get_parent()
onready var original_collision_mask = collision_mask
onready var original_collision_layer = collision_layer

# Who picked us up?
var picked_up_by = null
var center_pickup_on_node = null
var by_controller : ARVRController = null
var closest_count = 0

var thrown = false

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
	var collidingBodies = self.get_colliding_bodies()
	for body in collidingBodies:
		var type = body.get_type()
		if body.get_type() == "Cube":
			# Todo Hier die Logik einbauen da ein Cube nicht aufhebar ist
			# Testen wenn das Laufen eingefügt ist
			
			var bodyPos = body.translation
			var selfPos = self.translation
			var distanceX = self.translation.x - body.translation.x
			var distanceY = self.translation.y - body.translation.y
			var distanceZ = self.translation.z - body.translation.z
			#quadratrechnung verwenden ? lieber nicht
			
			#vil nnur abbrechen des Pickups wenn möglich, statt mode abändern
			#self.set_mode(1)
			#var bodyMode = self.get_mode() 
			# self.translation.x
			var test
	
	
	if thrown:
		thrown = false
	
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
	if original_parent:
		original_parent.get_parent().remove_child(self)
	picked_up_by.add_child(self)
	
	if reset_transform_on_pickup:
		# reset our transform
		if center_pickup_on_node:
			transform = center_pickup_on_node.global_transform.inverse() * global_transform
		else:
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
		original_parent.get_parent().add_child(self)
		
		# reposition it and apply impulse
		global_transform = t
		mode = RigidBody.MODE_RIGID
		# reposition it and apply impulse
		
		# für Bitmaske: die ersten 3 Bits sind auf true gesetzt
		collision_mask = 7
		collision_layer = 7
		
		# set our starting velocity
		linear_velocity = starting_linear_velocity * 10
		
		#apply_impulse(Vector3(0.0, 0.0, 0.0), impulse)
		
		# we are no longer picked up
		picked_up_by = null
		by_controller = null
		
func _ready():	
	if center_pickup_on:
		# if we have center pickup on set obtain our node
		center_pickup_on_node = get_node(center_pickup_on) 
