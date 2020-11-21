extends Node


var players = {}
var playerScenes = {}


func _ready():
	rng.randomize();
	
	load_all()
		
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self,"_player_disconnected")
	
	

var rng = RandomNumberGenerator.new()

var startLevel = "Start"

func _player_connected(id):
	
	print("player with ID " + str(id) + " connected")
		
	var player = load("res://client.tscn").instance()
	player.set_name(str(id))
	
	get_node("/root/World/Players").add_child(player)
	
	players[id] = id
	playerScenes[id] = player
	
	rpc_id(id, "pre_start_game")


func init_random_map(id, mapInstance):
	
	mapInstance.name = "Random" + str(mapInstance.get_instance_id())
	get_node("/root/World/Maps/").add_child(mapInstance)
	
	init_map(id, mapInstance.name, mapInstance.mapDict)
		
func init_map(id, mapName, tileMap = null):
	
	var player = playerScenes[id]
	player.current_map = mapName
	
	var items = get_node("/root/World/Maps/" + mapName + "/Items").get_children()
	
	var itemDict = {}
	for item in items:
		itemDict[item.stats.id] = item.stats
		
	var mobs = get_node("/root/World/Maps/" + mapName + "/Mobs").get_children()
	
	var mobDict = {}
	for mob in mobs:
		var mobID = mob.get_instance_id()
		mobDict[mobID] = {}
		mobDict[mobID]["name"] = mob.name
		mobDict[mobID]["mobname"] = mob.mobName
		mobDict[mobID]["x"] = mob.position.x
		mobDict[mobID]["y"] = mob.position.y
		if mob.has_node("Weapon"):
			var weapon = mob.get_node("Weapon")["stats"]
			mobDict[mobID]["weapon"] = weapon
		


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
		
	
	var startPosition = get_random_start(mapName)
		
	if mapName.substr(0, 6) == "Random":
		var n = get_node("/root/World/Maps/" + mapName)
		tileMap = n.mapDict
		
	rpc_id(id, "init_map", mapName, startPosition, itemDict, mobDict, portalDict, tileMap)
	
	
var spawnsUsed = Array()
func get_random_start(mapName):
	var startPosition = Vector2.ZERO
	var spawnPoints = get_node("/root/World/Maps/" + mapName + "/SpawnPoints").get_children()
	
	if spawnsUsed.size() == spawnPoints.size():
		spawnsUsed = Array()
	
	var s = rng.randi_range(0, spawnPoints.size() - 1)
	while spawnsUsed.has(s):
		s = rng.randi_range(0, spawnPoints.size() - 1)
		
	var i = 0
	for spawn in spawnPoints:
		if i == s:
			startPosition = spawn.get_position()
			spawnsUsed.append(i)
			break
		i = i + 1
		
	return startPosition

var playerState = {}

func _player_disconnected(id):
	
	var player = get_node("/root/World/Players/" + str(id))
	
	var playerName = players[id]
	playerState[playerName] = {}
	playerState[playerName]["x"] = player.puppet_pos.x
	playerState[playerName]["y"] = player.puppet_pos.y
	playerState[playerName]["map"] = player.current_map
	print("pp" + str(player.puppet_pos.x))
	playerState[playerName]["items"] = player.items
	
	print("player " + str(id) + " (" + str(players[id]) + ") disonnected")
	get_node("/root/World/Players").remove_child(playerScenes[id])
	players.erase(id)
	
	_refresh_playerlist()
	


remote func register_player_server(new_player_name):
	var id = get_tree().get_rpc_sender_id()
	print("register player with id ", id, " as ", new_player_name)
	
	var map = startLevel
	var pos = Vector2.ZERO
	if playerState.has(new_player_name):
		map = playerState[new_player_name]["map"]
		init_map(id, playerState[new_player_name]["map"]) 
		pos.x = playerState[new_player_name]["x"] 
		pos.y = playerState[new_player_name]["y"] 
	else:
		pos = get_random_start(map)
		init_map(id, map)
	
	for p in players:
		if p != id:
			var items = {}
			if playerState.has(new_player_name):
				items = playerState[new_player_name].items
			rpc_id(p, "register_player", id, new_player_name, map, pos, items)
			rpc_id(id, "register_player", p, playerScenes[p].player_name, playerScenes[p].current_map, playerScenes[p].position, playerScenes[p].items)
		if p == id:
			if playerState.has(new_player_name):
				rpc_id(p, "init_player", playerState[new_player_name])
	
			
	players[id] = new_player_name
	playerScenes[id].set_player_name(new_player_name, players.size())
	
	if playerState.has(new_player_name):
		#playerScenes[id].puppet_pos = pos
		playerScenes[id].items = playerState[new_player_name]["items"] # load items
		
	_refresh_playerlist()


func _refresh_playerlist():
	print("updating player list:")
	for player in gamestate.players:
		print(str(player) + ": " + str(gamestate.players[player]))
		

func _notification(event):
	if event == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
	
		for p in players:
			_player_disconnected(p)
			
		save()














		
var save_game

func save():
	for map in get_node("/root/World/Maps").get_children():
		save_game = File.new()
		save_game.open("user://" + map.name + ".save", File.WRITE)
		var nodes = map.get_children()
		save_all_nodes(nodes)
		save_player_states(map.name)
		save_game.close()
	
func save_all_nodes(nodes):
	for n in nodes:
		print("Saving " + n.get_name())
		save_node(n)	
		if n.get_child_count() > 0:
			save_all_nodes(n.get_children())

func save_player_states(mapName):
	
	var dict = {}
	dict["players"] = {}
	
	for state in playerState:
		if playerState[state].map == mapName:
			dict["players"][state] = playerState[state]
	
	save_game.store_line(to_json(dict))


func save_node(node):
	if !node.has_method("save"):
		print("No save function for %s" % node.name)
		return

	var node_data = node.call("save")

	save_game.store_line(to_json(node_data))



func load_all():
	return
	for map in get_node("/root/World/Maps").get_children():
		var save_game = File.new()
		if not save_game.file_exists("user://" + map.name + ".save"):
			return
			
		for mob in map.get_node("Mobs").get_children():
			mob.queue_free()
		for item in map.get_node("Items").get_children():
			item.queue_free()

		save_game.open("user://" + map.name + ".save", File.READ)
		
		while save_game.get_position() < save_game.get_len():
			var node_data = parse_json(save_game.get_line())

			for i in node_data.keys():
				if i == "players":
					if node_data[i]:
						for p in node_data[i]:
							playerState[p] = node_data[i][p]
					continue
				if i == "mob":
					if node_data[i]:
						var mob = load("res://mob.tscn").instance()
						mob.name = node_data[i]["name"]
						mob.mobName = node_data[i]["mobname"]
						mob.position.x = node_data[i]["x"]
						mob.position.y = node_data[i]["y"]
						mob.puppet_pos.x = node_data[i]["x"]
						mob.puppet_pos.y = node_data[i]["y"]
						print(mob.name)
						if node_data[i].has("items"):
							mob.items = node_data[i]["items"]
						map.get_node("Mobs").add_child(mob)
				if i == "item":
					if node_data[i]:
						var item = load("res://Item.tscn").instance()
						item.stats = node_data[i]
						item.id = node_data[i]["id"]
						item.position.x = node_data[i]["x"]
						item.position.y = node_data[i]["y"]
						map.get_node("Items").add_child(item)

		save_game.close()
