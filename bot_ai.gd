extends Node

# Hier werden zentrale bei Spielstart erzeugte Nodes abgelegt, die
# von überall einfach zu erreichen sind und nur einmalig im Spiel existieren!
var bots = []
var game_start = false

func register_bot(bot):
	bots.append(bot)

func start():
	game_start = true
