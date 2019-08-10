extends Node

const DEFAULT_IP = '127.0.0.1'
const DEFAULT_PORT = 31400
const MAX_PLAYERS = 4

var player_id
var client_ids = []
var _player_info = null
const DEFAULT_PLAYER_INFO = "{}"

signal client_list_changed_signal
signal connection_succeeded_signal
signal hosting_succeeded_signal
signal client_connected_signal(id) #server only
signal client_disconnected_signal(id) #server only

func _ready():
	get_tree().connect("network_peer_connected", self, "_network_peer_connected")
	get_tree().connect("network_peer_disconnected", self,"_network_peer_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_to_server")
	get_tree().connect("connection_failed", self, "_connected_failed")
	get_tree().connect("server_disconnected", self, "_server_disconnected")

func i_am_host():
	return player_id==1

#checks if rpc caller is server
func is_from_server():
	var sender_id = get_tree().get_rpc_sender_id()
	if sender_id == 1 or (sender_id==0 and i_am_host()):
		return true
	else:
		return false

func host_game(player_info):
	player_id = 1
	var host = NetworkedMultiplayerENet.new()
	host.create_server(DEFAULT_PORT, MAX_PLAYERS)
	get_tree().set_network_peer(host)
	client_ids = []
	_player_info = {}
	_player_info.info = player_info
	_player_info.id = player_id
	client_ids.append(player_id)
	emit_signal("client_list_changed_signal")
	emit_signal("hosting_succeeded_signal")

func join_game(ip, player_info):
	var host = NetworkedMultiplayerENet.new()
	host.create_client(ip, DEFAULT_PORT)
	get_tree().set_network_peer(host)
	player_id = get_tree().get_network_unique_id()
	_player_info = {}
	_player_info.info = player_info
	_player_info.id = player_id
	
#called on other clients and server once for everyone connected.
func _network_peer_connected(id):
	print(id, "peer connected to server")
	if get_tree().get_network_unique_id()==1:
		client_ids.append(id)
		rpc("update_client_list",client_ids)
		emit_signal("client_list_changed_signal")
		emit_signal("client_connected_signal", id)
		
sync func update_client_list(client_ids):
	if is_from_server():
		self.client_ids = client_ids
		emit_signal("client_list_changed_signal")

func get_clients():
	return client_ids

func get_player_id():
	return player_id
	
#called on clients and server when a client disconnects
func _network_peer_disconnected(id):
	print(id, "peer disconnected from server")
	if get_tree().get_network_unique_id()==1:
		client_ids.erase(id)
		rpc("update_client_list",client_ids)
		emit_signal("client_list_changed_signal")
		emit_signal("client_disconnected_signal", id)
	pass
	
#called on client when connected to server
func _connected_to_server():
	player_id = get_tree().get_network_unique_id()
	print("connected to server")
	emit_signal("connection_succeeded_signal")
	
func _connection_failed():
	print("failed to connect to server")
	
func _server_disconnected():
	print("server disconnected")