extends RigidBody

var current_holding = null
var is_wall = false
var group = null

# Growing Logic
var is_growing = false
var current_growth_value = 0
var end_height = 15
var growing_steps = 0.5
var current_booster = null

var current_color = 'white'

func ready():
	end_height = get_node("/root/config").world_height

func _process(delta):
	if is_growing:
		var current_value = current_growth_value + growing_steps
		rescaleYTo(current_value)
		current_growth_value = current_value
		
		if current_growth_value >= end_height:
			rescaleYTo(end_height)
			is_growing = false
			is_wall = true

func grow():
	is_growing = true
	paint_self(current_color, 1)

func spawn_booster(booster_instance):
	if not current_booster:
		current_booster = booster_instance
		self.add_child(booster_instance)

func set_current_holding(child):
	current_holding = child

func remove_current_holding():
	remove_child(current_holding)

func get_current_holding():
	return current_holding

func is_holding(compare):
	if current_holding == compare:
		return true
	else:
		return false

func set_to_wall():
	rescaleYTo(end_height)

func rescaleYTo(value):
	var new_scale = Vector3(1, value, 1)
	self.set_scale(new_scale)
	$CollisionShape.set_scale(new_scale)
	# TODO: paint into color of the players

func set_is_wall(set_is_wall, set_group):
	group = set_group
	is_wall = set_is_wall

func get_group():
	return group

func get_is_wall():
	return is_wall

func get_type():
	return 'HexTile'

func paint_self(color, material_index=0):
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
	
	current_color = color
	
	$CollisionShape.get_child(0).set_surface_material(material_index, material)
	
func get_Color():
	return current_color

func flip():
	rotate_x(deg2rad(180))

func _on_HexTile_input_event(camera, event, click_position, click_normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed == true:
			print("is_wall: " + str(get_is_wall()))
			print("is_roof: " + str(get_parent().roof))
			print("Hex Left Mouse Button")
		if event.button_index == BUTTON_LEFT and event.pressed == false:
			print("is_wall: " + str(get_is_wall()))
			print("is_roof: " + str(get_parent().roof))
			print("Hex Left Mouse Button Release")
		if event.button_index == BUTTON_RIGHT and event.pressed == true:
			print("Hex Pressed Right Mouse Button")
		if event.button_index == BUTTON_RIGHT and event.pressed == false:
			print("Hex Right Mouse Button Release")
		if event.button_index == BUTTON_MIDDLE and event.pressed == true:
			print("Hex Pressed Middle Mouse Button")
		if event.button_index == BUTTON_MIDDLE and event.pressed == false:
			print("Hex Middle Mouse Button Release")
		if event.button_index == BUTTON_LEFT and event.doubleclick == true:
			print("Hex Left Mouse Button Double Clicked")
