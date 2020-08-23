extends Node

const SERVER_PORT = 31400
const MAX_PLAYERS = 2
const SERVER_IP = "127.0.0.1"

var players = { }
var self_data = { name = '', position = Vector3(0,0,0)}
var is_server = true

var player_name

var player_color = [
	'red',
	'blue',
	'greeb',
	'yellow'
]

var given_color = [
	
]

var rng

func _ready():
	get_tree().connect('network_peer_connected', self, '_player_connected')
	get_tree().connect('network_peer_disconnected', self, '_player_disconnected')
	get_tree().connect('connected_to_server', self, '_connected_ok')
	get_tree().connect('connection_failed', self, '_connected_fail')
	get_tree().connect('server_disconnected', self, '_server_disconnect')
	rng = RandomNumberGenerator.new()

func start_server():
	player_name = "Server"
	var peer = NetworkedMultiplayerENet.new()
	var err = peer.create_server(SERVER_PORT, MAX_PLAYERS)
	
	if (err!=OK):
		join_server()
		return
	
	get_tree().network_peer = peer

	spawn_player(1)

func join_server():
	player_name = "client"
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(SERVER_IP, SERVER_PORT)
	get_tree().network_peer = peer

func _connected_ok():
	# Wenn sich ein client verbindet, muss auf dem Server user_ready aufgerufen werden!
	rpc_id(1, 'user_ready', get_tree().get_network_unique_id(), player_name)

func _connected_fail():
	pass

func _server_disconnect():
	quit_game()

func _player_connected(id):
	pass

func _player_disconnected(id):
	unregister_player(id)
	rpc("unregister_player", id)

remote func user_ready(id, info):
	# Wird nur auf dem Server verwendet, sobald sich ein Client verbunden hat
	if get_tree().is_network_server():
		# Server sendet an den client, dass er sich am Spiel registrieren soll!
		rpc_id(id, "register_in_game")

remote func register_in_game():
	# fordert alle anderen verbundenen teilnehmer auf, den neuen Spieler zu registrieren
	rpc("register_new_player", get_tree().get_network_unique_id(), player_name)
	# registriert den neuen Spieler bei sich
	register_new_player(get_tree().get_network_unique_id(), player_name)

remote func register_new_player(id, name):
	# Der Server hat immer alle Player
	# Daher, wenn ein neuer Spieler registriert werden soll (neuer client)
	# Fordert der Server diesen neuen client auf, auch alle bisherigen Spieler zu registrieren
	if get_tree().is_network_server():
		rpc_id(id, "register_new_player", 1, player_name)
		
		for peer_id in players:
			rpc_id(id, "register_new_player", peer_id, players[peer_id])
	
	# Registriere den neuen Spieler
	spawn_player(id)

remote func unregister_player(id):
	if get_node("/root/World/" + str(id)):
		get_node("/root/World/" + str(id)).queue_free()
	
	players.erase(id)

func quit_game():
	get_tree().set_network_peer(null)
	players.clear()

func spawn_player(id):
	var player_scene = load("res://Player/Player.tscn")
	var player = player_scene.instance()
	
	player.set_name(str(id))
	player.translate(Vector3(0,2,0))
	
	rng.randomize()
	var size = len(player_color)
	var random_color_index = rng.randi_range(0, size-1)
	var curr_color = player_color[random_color_index]
	
	player.set_color(curr_color)
	
	if id == get_tree().get_network_unique_id():
		# Spieler ist nur der Netzwerk Meister des eigenen Characters für Input Controls
		player.set_network_master(id)
		player.player_id = id
		player.control = true
	

	if not id in players.keys():
		players[id] = player
	
	get_parent().add_child(player)

func get_network_peer():
	return get_tree().get_network_peer()

func is_Server():
	return get_tree().is_network_server()

func terminate_networking():
	get_tree().network_peer = null

func prevent_new_connections():
	get_tree().set_refuse_new_network_connection(true)

func player_died(id):
	rpc("r_player_died", id)

remote func r_player_died(id):
	var dead_player = players[id]
	var message = ''
	
	dead_player.queue_free()
	players.erase(id)
	
	if len(players) <= 1:
		if len(players) < 1:
			message = 'You were alone and killed yourself and therefore lost!'
		else:
			var survived_player = players[0]
			if survived_player.control:
				message = 'You have won'
			else:
				message = "You have lost"
		self.game_end(message)

func game_end(message):
	print(message)
