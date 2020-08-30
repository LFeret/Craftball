extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var id
var color
var life = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func set_color(set_color) -> void:
	color = set_color
	var material = SpatialMaterial.new()
	#var material = $MeshInstance.get_surface_material(0)
	
	match color:
		'red':
			material.albedo_color = Color(1,0,0)
		'blue':
			material.albedo_color = Color(0,0,1)
		'green':
			material.albedo_color = Color(0,1,0)
		'yellow':
			material.albedo_color = Color(1,1,0)
		'white':
			material.albedo_color = Color(1,1,1)
		'black':
			material.albedo_color = Color(0,0,0)
	
	$bot_body.get_child(0).set_surface_material(0, material)
	
func hit():
	life -= 1
	if life <= 0:
		self.die()

func die():
	self.queue_free()
	print("Bot Died. Grats")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
