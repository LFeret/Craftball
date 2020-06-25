extends Spatial

var current_holding = null

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

func _on_Area_input_event(camera, event, click_position, click_normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed == true:
			print("Hex Left Mouse Button")
		if event.button_index == BUTTON_LEFT and event.pressed == false:
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
