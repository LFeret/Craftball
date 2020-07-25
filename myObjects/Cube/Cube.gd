extends "res://myObjects/Cube/Cube_pickable.gd"

export var max_shots:int
var current_shot_count:int

var colorFirstShot = 'yellow'
var colorSecondShot = 'red'

var explosion

func _ready():
	max_shots = 3
	explosion = preload('res://leander/explosions/explosion.tscn')

# Todo: etxtra functions for cubes
func get_type():
	return 'Cube'

func _on_Cube_body_entered(body):
	
	if body.get_type() == 'ball':
		current_shot_count += 1
		if current_shot_count == 1:
			self.paint_self(colorFirstShot)
		elif current_shot_count == 2:
			self.paint_self(colorFirstShot)
		elif current_shot_count >= max_shots:
			"""
			var current_explosion = explosion.instance()
		
			var cube_position = get_global_transform().origin
			current_explosion.translate(cube_position)
			
			get_parent().get_parent().add_child(current_explosion)
			
			if is_instance_valid(self):
				self.queue_free()
			"""
	elif body.get_type() == 'HexTile':
		# überlegung interaktion mit Boden
		pass
	elif body.get_type() == "Cube":
		# überlegung interaktion mit Cube
		pass
		

func _on_Cube_body_exited(body):
	pass # Replace with function body.

func explode():
	var current_explosion = explosion.instance()
		
	var cube_position = get_global_transform().origin
	current_explosion.translate(cube_position)
	
	get_parent().get_parent().add_child(current_explosion)
	
	if is_instance_valid(self):
		self.queue_free()

func paint_self(color):
	var material = SpatialMaterial.new()
	#var material = $MeshInstance.get_surface_material(0)
	
	match color:
		'red':
			material.albedo_color = Color(1,0,0)
		'yellow':
			material.albedo_color = Color(1,1,0)
	
	#$CollisionSlhape.get_child(0).set_surface_material(0, material)
