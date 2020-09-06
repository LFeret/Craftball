extends Node

# Hier werden zentrale bei Spielstart erzeugte Nodes abgelegt, die
# von überall einfach zu erreichen sind und nur einmalig im Spiel existieren!
var bots = []
var game_start = false

var time = 0
var timerVar = 0

var scan_intervall = 10
var scan_radius = 5
var scan = false

var rng

func register_bot(bot):
	bots.append(bot)

func start():
	game_start = true

func _ready():
	rng = RandomNumberGenerator.new()

func _process(delta):
	timerVar += delta
	
	if timerVar >= 1:
		# ~ 1 Second gone
		time += 1
		timerVar = 0
	
	if time % scan_intervall == 0:
		time = 0
		scan = true
	
	for bot in bots:
		if scan:
			var go_to_player = rng.randi_range(0, 1)
			if go_to_player == 1:
				var networking = get_node("/root/global/").networking
				var player = null
				for peer_id in networking.players:
					player = networking.players[peer_id]
				
				var player_position = player.get_global_transform().origin
				var bot_position = player.get_global_transform().origin
				
				var distance = bot_position.distance_to(player_position)
				if distance <= scan_radius:
					if bot:
						bot.set_player_pos(player_position)
				else:
					var random_x = null
					var random_z = null
					random_x = rng.randi_range(-5, 5)
					random_z = rng.randi_range(-5, 5)
					if bot:
						bot.set_player_pos(Vector3(random_x, 0, random_z))
			else:
					var random_x = null
					var random_z = null
					random_x = rng.randi_range(-5, 5)
					random_z = rng.randi_range(-5, 5)
					if bot:
						bot.set_player_pos(Vector3(random_x, 0, random_z))

	scan = false
