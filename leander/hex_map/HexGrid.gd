extends Spatial

var hex_tile

var node_player

export var grid_w:int=9
export var grid_h:int=9

var hex_w:float=1.73205
var hex_h:float=2.0

var start_pos:Vector3

var hexes = []

# Called when the node enters the scene tree for the first time.
func _ready():
	hex_tile = preload("res://leander/hex_map/HexTile.res")
	calc_start_pos()
	create_grid()
	setup_map()

func calc_start_pos():
	var offset = hex_w / 2.0
	
	var x = -hex_w * grid_w/2.0 + offset/2.0
	var z = hex_h * (grid_h/2.0) * 0.75 - offset
	start_pos = Vector3(x,0,z)

func calc_world_pos(var grid_pos : Vector2):
	var offset = 0.0 
	if int(grid_pos.y) % 2 != 0:
		offset = hex_w/2
		grid_w -= 1
	else:
		grid_w += 1
	
	var x = start_pos.x + grid_pos.x * hex_w + offset
	var z = start_pos.z - grid_pos.y * hex_h * 0.75
	return (Vector3(x, 0, z))


func create_grid():
	for x in range(grid_w):
		for y in range (grid_h):
			var hex = hex_tile.instance()
			var grid_pos = Vector2(x,y)
			hex.set_name(str(x) + "|" + str(y))
			add_child(hex)
			var hex_pos = calc_world_pos(grid_pos)
			hex.set_translation(hex_pos)
			hexes.append(hex)

func setup_map():
	var i = 0
	for hex in hexes:
		# you can add objects to initialize over the map here
		
		i += 1
