extends Spatial


# leander stuff
var networking

# Called when the node enters the scene tree for the first time.
func _ready():
	var networking_script = load("res://leander/multiplayer/network.gd")
	networking = networking_script.new()
	get_node("/root/global/").networking = networking
	add_child(networking)
	networking.start_server()
