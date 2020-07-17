extends Spatial

var hex_tile

var node_player

export var grid_w:int=20
export var grid_h:int=20

var hex_w:float=1.73205
var hex_h:float=2.0

var start_pos:Vector3

var rng
var hexes = []
var growable_hexes = []
var roof = false

var booster_reg

var roof_height = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	roof_height = get_node("/root/config").world_height
	booster_reg = get_node("/root/booster_registry")
	roof = get_parent().roof
	rng = RandomNumberGenerator.new()
	hex_tile = preload("res://leander/hex_map/HexTile.res")
	
	if not roof:
		get_node("/root/global").board = self
	
	calc_start_pos()
	create_grid()
	setup_map()

func calc_start_pos():
	var offset = hex_w / 2.0
	
	var x = -hex_w * grid_w/2.0 + offset/2.0
	var z = hex_h * (grid_h/2.0) * 0.75 - offset
	var y = 0
	if roof:
		y = roof_height
	start_pos = Vector3(x,y,z)

func calc_world_pos(var grid_pos : Vector2):
	var offset = 0.0 
	if int(grid_pos.y) % 2 != 0:
		offset = hex_w/2
		grid_w -= 1
	else:
		grid_w += 1
	
	var x = start_pos.x + grid_pos.x * hex_w + offset
	var z = start_pos.z - grid_pos.y * hex_h * 0.75
	var y = 0
	if roof:
		y = roof_height
	return (Vector3(x, y, z))

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
			
			if not roof:
				if y == 0:
					hex.set_is_wall(true)
				elif x == 0:
					hex.set_is_wall(true)
				if y == 1:
					hex.set_is_wall(true)
				elif x == 1:
					hex.set_is_wall(true)
				elif y+1 == grid_h:
					hex.set_is_wall(true)
				elif x+1 == grid_w:
					hex.set_is_wall(true)
				elif y+2 == grid_h:
					hex.set_is_wall(true)
				elif x+2 == grid_w:
					hex.set_is_wall(true)
				else:
					growable_hexes.append(hex)
			else:
				hex.flip()

func setup_map():
	var i = 0
	for hex in hexes:
		if hex.get_is_wall():
			hex.set_to_wall()
		
		i += 1

func grow():
	var usable_hex = get_random_usabel_hex(true)
	usable_hex.grow()

func spawn_booster():
	var usable_hex = get_random_usabel_hex()
	
	usable_hex.spawn_booster(get_random_booster())

func get_random_usabel_hex(remove = false):
	rng.randomize()
	var size = growable_hexes.size()
	var random_hex_index =  rng.randi_range(0, size-1)
	var growable_hex = growable_hexes[random_hex_index]
	if remove:
		growable_hexes.remove(random_hex_index)
	return growable_hex

func get_random_booster():
	rng.randomize()
	var size = booster_reg.get_booster_count()
	var random_booster_index = rng.randi_range(0, size-1)
	return booster_reg.get_booster(random_booster_index)
