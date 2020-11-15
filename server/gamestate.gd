extends Node


var players = {}
var playerScenes = {}


func _ready():
	rng.randomize();
	
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self,"_player_disconnected")
	
	

var rng = RandomNumberGenerator.new()

var startLevel = "Start"
var startPosition = Vector2.ZERO

func _player_connected(id):
	
	print("player with ID " + str(id) + " connected")
		
	var player = load("res://client.tscn").instance()
	player.set_name(str(id))
	
	get_node("/root/World/Players").add_child(player)
	
	players[id] = id
	playerScenes[id] = player
	
	rpc_id(id, "pre_start_game", startLevel)
	
	init_map(id, startLevel)


func init_map(id, mapName):
	
	var player = playerScenes[id]
	player.current_map = mapName
	
	var spawnPoints = get_node("/root/World/Maps/" + mapName + "/SpawnPoints").get_children()
	var s = rng.randi_range(0, spawnPoints.size() - 1)
	var i = 0
	for spawn in spawnPoints:
		if i == s:
			startPosition = spawn.get_position()
		i = i + 1
		
	
#	var d = inst2dict(items)
	
	rpc_id(id, "init_map", mapName, startPosition)
	
	var items = get_node("/root/World/Maps/" + mapName + "/Items").get_children()
	
	var itemDict = {}
	for item in items:
		itemDict[item.stats.id] = item.stats
		
		
	rpc_id(id, "create_items", itemDict)
	
	var mobs = get_node("/root/World/Maps/" + mapName + "/Mobs").get_children()
	
	var mobDict = {}
	for mob in mobs:
		var mobID = mob.get_instance_id()
		mobDict[mobID] = {}
		mobDict[mobID]["name"] = mob.mobName
		mobDict[mobID]["x"] = mob.position.x
		mobDict[mobID]["y"] = mob.position.y
		if mob.has_node("Weapon"):
			var weapon = mob.get_node("Weapon")["stats"]
			mobDict[mobID]["weapon"] = weapon
		
	rpc_id(id, "create_mobs", mobDict)


	var portals = get_node("/root/World/Maps/" + mapName + "/Portals").get_children()
	
	var portalDict = {}
	for portal in portals:
		var portalID = portal.get_instance_id()
		portalDict[portalID] = {}
		portalDict[portalID]["name"] = portal.get_name()
		portalDict[portalID]["id"] = portalID
		portalDict[portalID]["x"] = portal.position.x
		portalDict[portalID]["y"] = portal.position.y
		portalDict[portalID]["targetScene"] = portal.targetSceneName
		portalDict[portalID]["triggerName"] = portal.triggerName
		portalDict[portalID]["color"] = portal.color
		
	rpc_id(id, "create_portals", portalDict)

	
	

var playerState = {}

func _player_disconnected(id):
	
	var player = get_node("/root/World/Players/" + str(id))
	
	var playerName = players[id]
	playerState[playerName] = {}
	playerState[playerName]["x"] = player.puppet_pos.x
	playerState[playerName]["y"] = player.puppet_pos.y
	print("pp" + str(player.puppet_pos.x))
	playerState[playerName]["items"] = player.items
	
	print("player " + str(id) + " (" + str(players[id]) + ") disonnected")
	get_node("/root/World/Players").remove_child(playerScenes[id])
	players.erase(id)
	
	_refresh_playerlist()
	


remote func register_player_server(new_player_name):
	var id = get_tree().get_rpc_sender_id()
	print("register player with id ", id, " as ", new_player_name)
	
	var pos = startPosition
	if playerState.has(new_player_name):
		pos.x = playerState[new_player_name]["x"] 
		pos.y = playerState[new_player_name]["y"] 
	
	for p in players:
		if p != id:
			rpc_id(p, "register_player", id, new_player_name, startLevel, pos)
		if p == id:
			if playerState.has(new_player_name):
				rpc_id(p, "init_player", playerState[new_player_name])
	
			
	players[id] = new_player_name
	playerScenes[id].set_player_name(new_player_name, players.size())
	
	if playerState.has(new_player_name):
		#playerScenes[id].puppet_pos = pos
		playerScenes[id].items = playerState[new_player_name]["items"] 
		
	_refresh_playerlist()


func _refresh_playerlist():
	print("updating player list:")
	for player in gamestate.players:
		print(str(player) + ": " + str(gamestate.players[player]))
		



