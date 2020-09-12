extends Node

# Hier werden zentrale bei Spielstart erzeugte Nodes abgelegt, die
# von überall einfach zu erreichen sind und nur einmalig im Spiel existieren!
var bots = []

func register_bot(bot):
	bots.append(bot)
	
func delete_bots():
	for bot in bots:
		bot.queue_free()
	bots.clear()
