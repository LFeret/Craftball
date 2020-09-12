extends Spatial


# leander stuff
var networking
var bots = {}
var sinlge_player = null

# Called when the node enters the scene tree for the first time.
func _ready():
	var networking_script = load("res://leander/multiplayer/network.gd")
	var bot_script = load("res://leander/bots/bot.tscn")
	var bot_ai = get_node("/root/botai")
	var rng = RandomNumberGenerator.new()
	networking = networking_script.new()
	get_node("/root/global/").networking = networking
	add_child(networking)
	networking.start_server()
	
	var start_vectors = [
		Vector3(2, 0, 2),
		Vector3(-2, 0, -2),
		Vector3(-2, 0, 2)
	]
	
	for i in range(1,4):
		var bot = bot_script.instance()
		bot.id = i
		bots[i] = bot
		bot.translate(start_vectors[i-1])
		var player_color = networking.player_color
		var size = len(player_color)
		var random_color_index = rng.randi_range(0, size-1)
		var curr_color = player_color[random_color_index]
		
		bot.set_color(curr_color)
		player_color.remove(random_color_index)

		bot_ai.register_bot(bot)
		add_child(bot)
