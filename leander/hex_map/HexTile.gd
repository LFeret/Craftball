extends RigidBody

var current_holding = null
var is_wall = false

# Growing Logic
var is_growing = false
var current_growth_value = 0
var end_height = 15
var growing_steps = 0.5

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


func set_is_wall(set_is_wall):
	is_wall = set_is_wall

func get_is_wall():
	return is_wall

func get_type():
	return 'HexTile'

func paint_self(color):
	var material = SpatialMaterial.new()
	#var material = $MeshInstance.get_surface_material(0)
	
	match color:
		'red':
			material.albedo_color = Color(1,0,0)
	
	$CollisionShape.get_child(0).set_surface_material(0, material)

func _on_HexTile_input_event(camera, event, click_position, click_normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed == true:
			print("is_wall: " + str(get_is_wall()))
			print("Hex Left Mouse Button")
		if event.button_index == BUTTON_LEFT and event.pressed == false:
			print("is_wall: " + str(get_is_wall()))
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
