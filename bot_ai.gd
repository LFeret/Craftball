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
var start = true

var rng

func register_bot(bot):
	bots.append(bot)

func start():
	game_start = true

func _ready():
	rng = RandomNumberGenerator.new()
	
func _process(delta):
	if start:
		for bot in bots:
			var random_x = null
			var random_z = null
			random_x = rng.randi_range(-10, 10)
			random_z = rng.randi_range(-10, 10)
			bot.set_player_pos(Vector3(random_x, 0, random_z))
			
			start = false
