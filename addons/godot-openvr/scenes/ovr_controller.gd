extends ARVRController

signal controller_activated(controller)

export var show_controller_mesh = true setget set_show_controller_mesh, get_show_controller_mesh

# leander stuff
const ball = preload("res://leander/ball/ball.res")
var player = null

func set_show_controller_mesh(p_show):
	show_controller_mesh = p_show
	if $Controller_mesh:
		$Controller_mesh.visible = p_show

func get_show_controller_mesh():
	return show_controller_mesh

var ovr_render_model
var components = Array()
var ws = 0

func _ready():
	# instance our render model object
	ovr_render_model = preload("res://addons/godot-openvr/OpenVRRenderModel.gdns").new()
	
	# set our starting vaule
	$Controller_mesh.visible = show_controller_mesh
	
	# hide to begin with
	visible = false

func apply_world_scale():
	var new_ws = ARVRServer.world_scale
	if (ws != new_ws):
		ws = new_ws
		$Controller_mesh.scale = Vector3(ws, ws, ws)

func load_controller_mesh(controller_name):
	if ovr_render_model.load_model(controller_name.substr(0, controller_name.length()-2)):
		return ovr_render_model
	
	if ovr_render_model.load_model("generic_controller"):
		return ovr_render_model
	
	return Mesh.new()

func _process(delta):
	if !get_is_active():
		visible = false
		return
	
	# TODO: Leander oder Mandy Generiere Bewegungspunkte Hinstorie für Werfen force Vector ermittlung
	
	# always set our world scale, user may end up changing this
	apply_world_scale()
	
	if visible:
		return
	
	# became active? lets handle it...
	var controller_name = get_controller_name()
	print("Controller " + controller_name + " became active")
			
	# attempt to load a mesh for this
	$Controller_mesh.mesh = load_controller_mesh(controller_name)
			
	# make it visible
	visible = true
	emit_signal("controller_activated", self)
	
	
func button_pressed(button_index):
	# If the trigger is pressed...
	if button_index == 15:
		print("# button geht#####")
			# leander stuff: ball_creation Input
		var current_ball = ball.instance()
		current_ball.sleeping = true
		# Set Ball Position
		current_ball.translate(Vector3(0,2,0))
			
		player.set_ball_to_right_hand(current_ball)
		
func button_released(button_index):
	 # If the trigger button is released...
	if button_index == 15  and player.holds_ball():
		print("+++++++++Loslassen geht auch++++")
		player.throw_current_ball()


