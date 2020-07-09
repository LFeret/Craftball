extends Node

const SERVER_PORT = 31400
const MAX_PLAYERS = 2
const SERVER_IP = "127.0.0.1"

var players = { }
var self_data = { name = '', position = Vector3(0,0,0)}
var is_server = true

func initialize_as_server(player_name="Host"):
	self_data.name = player_name
	players[1] = self_data
	is_server = true
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(SERVER_PORT, MAX_PLAYERS)
	get_tree().network_peer = peer

func initiliaze_as_client(player_name="Client"):
	self_data.name = player_name
	is_server = false
	get_tree().connect('connected_to_server', self, '_connected_to_server')
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(SERVER_IP, SERVER_PORT)
	get_tree().network_peer = peer

func _connected_to_server():
	players[get_tree().get_network_unique_id()] = self_data
	rpc('_send_player_info', get_tree().get_network_unique_id(), self_data)

remote func _send_player_info(id, info):
	if get_tree().is_network_server():
		for peer_id in players:
			rpc_id(id, '_send_player_info', peer_id, players[peer_id])
	
	players[id] = info
	
	var new_player = load("res://Player/Player.tscn").instance()
	new_player.name = str(id)
	new_player.set_network_master(id)
	get_tree().get_root().add_child(new_player)
	new_player.init(info.name, info.position, true)

func get_network_peer():
	return get_tree().get_network_peer()

func is_Server():
	return get_tree().is_network_server()

func terminate_networking():
	get_tree().network_peer = null

func prevent_new_connections():
	get_tree().set_refuse_new_network_connection(true)



