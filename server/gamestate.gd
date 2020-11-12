extends Node


var players = {}
var playerScenes = {}


func _ready():
	rng.randomize();
	
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self,"_player_disconnected")
	
	

var rng = RandomNumberGenerator.new()

var startLevel = "Start"

func _player_connected(id):
	
	print("player with ID " + str(id) + " connected")
		
	var player = load("res://client.tscn").instance()
	player.set_name(str(id))
	player.current_map = startLevel
	
	get_node("/root/World/Players").add_child(player)
	
	
	var spawnPoints = get_node("/root/World/Maps/" + startLevel + "/SpawnPoints").get_children()
	var s = rng.randi_range(0, spawnPoints.size() - 1)
	var i = 0
	var startPosition = Vector2.ZERO
	for spawn in spawnPoints:
		if i == s:
			startPosition = spawn.get_position()
		i = i + 1
		
	var items = get_node("/root/World/Maps/" + startLevel + "/Items").get_children()
	
	var itemDict = {}
	for item in items:
		#var stats = item.get_property_list()["stats"]
		itemDict[item.stats.id] = item.stats
	
#	var d = inst2dict(items)
	
	rpc_id(id, "pre_start_game", startLevel, startPosition)
	
	rpc_id(id, "create_items", itemDict)

	for pl in players:
		# IF PLAYER IN SAME LEVEL
		rpc_id(id, "register_player", pl, players[pl], startLevel, startPosition) 
	
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
		



