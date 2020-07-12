extends KinematicBody

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 100
var location = Vector3()
var gravity = -10
var velocity = Vector3()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
# Tamer stuff
func _physics_process(delta):
	location = Vector3(0,0,0)
	if Input.is_action_just_pressed("ui_left"):
		location.x -= 1
	if Input.is_action_just_pressed("ui_right"):
		location.x += 1
	if Input.is_action_just_pressed("ui_up"):
		location.z -= 1
	if Input.is_action_just_pressed("ui_down"):
		location.z += 1
	location = location.normalized()
	location = location*speed*delta
	
	velocity.y += gravity*delta
	velocity.x = location.x
	velocity.z = location.z
	
	velocity = move_and_slide(velocity, Vector3 (0,1,0))
	
	if is_on_floor() and Input.is_key_pressed(KEY_SPACE):
		velocity.y = 4
