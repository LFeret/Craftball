extends "res://mandy/Cube/Cube_pickable.gd"

export var max_shots:int
var current_shot_count:int

var colorFirstShot = 'yellow'
var colorSecondShot = 'red'

var explosion
var cube_sound

func _ready():
	max_shots = 3
	explosion = preload('res://leander/explosions/explosion.tscn')
	cube_sound = preload("res://mandy/Cube/car_door_close_1.wav")
	$audio.stream = cube_sound
	#set_contact_monitor(true)
	#set_max_contacts_reported(99999999)


# Todo: etxtra functions for cubes
func get_type():
	return 'Cube'
	
func count_hit():
	current_shot_count += 1
	if current_shot_count == 1:
		paint_self(colorFirstShot)
	elif current_shot_count == 2:
		paint_self(colorSecondShot)
	elif current_shot_count >= max_shots:
		explode()

func _on_Cube_body_entered(body):
	
	if body.get_type() == 'HexTile':
		$audio.play(0)
	elif body.get_type() == "Cube":
		#$audio.play(0)
		pass
	elif body.get_type() == "Ball":
		print(body.get_type())
	elif body.get_type() == "Player":
		print("PLAYER!")
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
	
	$CollisionShape.get_child(0).set_surface_material(0, material)





