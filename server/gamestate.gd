extends Node


var players = {}
var playerScenes = {}


func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self,"_player_disconnected")
	
	
func _player_connected(id):
	print("player with ID " + str(id) + " connected")
		
	var player = load("res://client.tscn").instance()
	player.set_name(str(id))
	
	get_node("/root/World/Players").add_child(player)
	
	rpc_id(id, "pre_start_game")

	for pl in players:
		rpc_id(id, "register_player", pl, players[pl])
	
	players[id] = id
	playerScenes[id] = player
	

func _player_disconnected(id):
	print("player " + str(id) + " (" + str(players[id]) + ") disonnected")
	get_node("/root/World/Players").remove_child(playerScenes[id])
	players.erase(id)
	
	_refresh_playerlist()
	


remote func register_player_server(new_player_name):
	var id = get_tree().get_rpc_sender_id()
	print("register player with id ", id, " as ", new_player_name)
	
	for p in players:
		if p != id:
			rpc_id(p, "register_player", id, new_player_name)
	
	players[id] = new_player_name
	playerScenes[id].set_player_name(new_player_name, players.size())
	
	_refresh_playerlist()


func _refresh_playerlist():
	print("updating player list:")
	for player in gamestate.players:
		print(str(player) + ": " + str(gamestate.players[player]))
		
