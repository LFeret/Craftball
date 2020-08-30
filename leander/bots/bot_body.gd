extends RigidBody

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 100
var location = Vector3()
var gravity = -10
var velocity = Vector3()

var bot


# Called when the node enters the scene tree for the first time.
func _ready():
	bot = get_parent()
	pass # Replace with function body.

func get_type():
	return 'Bot'

func hit():
	self.get_parent().hit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
# Tamer stuff
func _physics_process(delta):
	pass
