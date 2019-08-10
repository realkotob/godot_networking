class_name GameHost extends Node

var game = null

func _init(game: Game):
	self.game = game
	self.name = "GameHost"
	game.local_player_id = 1
	game.add_player(1)
	

func _ready():
	NetworkManager.connect("client_connected_signal", self, "_on_client_connected")
	NetworkManager.connect("client_disconnected_signal", self, "_on_client_disconnected")
	
	
func _on_client_connected(id):
	print("client connected: ", id)
	game.add_player(id)
	pass
	
func _on_client_disconnected(id):
	print("client disconnected: ", id)
	game.remove_player(id) #TODO have timeout
	pass