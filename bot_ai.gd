extends Node

# Hier werden zentrale bei Spielstart erzeugte Nodes abgelegt, die
# von überall einfach zu erreichen sind und nur einmalig im Spiel existieren!
var bots = []
var game_start = false

var time = 0
var timerVar = 0

var scan_intervall = 3
var scan_radius = 5
var scan = false

func register_bot(bot):
	bots.append(bot)

func start():
	game_start = true

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
			var networking = get_node("/root/global/").networking
			var player = null
			for peer_id in networking.players:
				player = networking.players[peer_id]
			
			var player_position = player.get_global_transform().origin
			var bot_position = player.get_global_transform().origin
			
			var distance = bot_position.distance_to(player_position)
			if distance <= scan_radius:
				bot.set_player_pos(player_position)

	scan = false
