extends Spatial


# leander stuff
var player = null
var networking

# Called when the node enters the scene tree for the first time.
func _ready():
	networking = get_node("/root/networking")
	
	if networking.is_server:
		networking.initialize_as_server()
	
	player = $player
	player.set_world(self)
	pass # Replace with function body.
