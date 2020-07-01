extends RigidBody

var current_holding = null
var is_wall = false

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
	set_scale(Vector3(1,200,1))
	set_translation(Vector3(translation.x, 18.5, translation.z))

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
	
	$MeshInstance.set_surface_material(0, material)
	print("Painted")

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
