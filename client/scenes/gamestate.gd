extends Node

const DEFAULT_PORT = 10567

var player_name = "The Warrior"

var players = {}
var playerScenes = {}

signal player_list_changed()
signal connection_failed()
signal connection_succeeded()
signal game_ended()
signal game_error(what)


func getPlayers():
	return players

func _player_connected(id):
	if id == 1:
		rpc_id(id, "register_player_server", player_name)


func _player_disconnected(id):
	unregister_player(id)


func _connected_ok():
	emit_signal("connection_succeeded")


func _server_disconnected():
	emit_signal("game_error", "Server disconnected")
	end_game()


func _connected_fail():
	get_tree().set_network_peer(null) # Remove peer
	emit_signal("connection_failed")


remote func init_player(playerInfo):
	
	var id = get_tree().get_network_unique_id()
	
	playerScenes[id].puppet_pos.x = playerInfo.x
	playerScenes[id].puppet_pos.y = playerInfo.y
	playerScenes[id].position.x = playerInfo.x
	playerScenes[id].position.y = playerInfo.y
	
	for it in playerInfo.items:
		var hn = null
		var i = playerInfo.items[it]
		if i.has("handNode"):
			hn = i.handNode
		var item = InventoryItem.new(i.id, i.name, i.label, i.description, i.image, i.icon, i.value, i.slotType, hn, i.level, i.rarity, i.stats)
		playerScenes[id].pickup_item(item)
		print(i.name)

	pass		
	
	
remote func register_player(id, new_player_name, mapName, spawn_pos):		
	print("register player with id", id, " as ", new_player_name)
	players[id] = new_player_name
	
	add_player_to_scene(id, spawn_pos, new_player_name, mapName)
	
	emit_signal("player_list_changed")


func unregister_player(id):
	players.erase(id)
	remove_player_from_scene(id)
	emit_signal("player_list_changed")


remote func pre_start_game(mapName, spawn_pos):
	# Change scene.
	print("pre start game")
	var world = load("res://scenes/World.tscn").instance()
	world.initStartMap(mapName)
	get_tree().get_root().add_child(world)
	var lobby = get_tree().get_root().get_node("Lobby")
	lobby.hide()
	lobby.get_node("Music").stopMusic()


	var id = get_tree().get_network_unique_id()
	
	add_player_to_scene(id, spawn_pos, player_name, mapName)
	
	get_tree().set_pause(false) # Unpause and unleash the game!
	get_node("/root/World").post_start_game()



func join_game(ip, new_player_name):
	player_name = new_player_name
	var client = NetworkedMultiplayerENet.new()
	client.create_client(ip, DEFAULT_PORT)
	get_tree().set_network_peer(client)


func get_player_list():
	return players.values()


func get_player_name():
	return player_name



func end_game():
	if has_node("/root/World"):
		get_node("/root/World").queue_free()

	players.clear()
	playerScenes.clear()


func remove_player_from_scene(id):
	
	get_node("/root/World/Players").remove_child(playerScenes[id])
	get_node("/root/World/CanvasLayer/Score").remove_player(id)


func add_player_to_scene(id, spawnpos, pname, mapName):
	
	var player_scene = load("res://actors/Player.tscn")
	var player = player_scene.instance()
	
	playerScenes[id] = player
	player.set_name(str(id)) # Use unique ID as node name.
	player.current_map = mapName
	player.position=spawnpos
	player.set_network_master(id) 
	player.set_player_name(pname)
	get_node("/root/World/Players").add_child(player)
	get_node("/root/World/CanvasLayer/Score").add_player(id, pname)
	
	if id == get_tree().get_network_unique_id():
		get_node("/root/World/CanvasLayer/MiniMap").player = "/root/World/Players/" + str(id)

remote func create_items(itemDict):
	
	print("creating items")
	
	
	for item in itemDict:
		var stats = itemDict[item]
		var newItem = load("res://items/equipment.tscn").instance()
		newItem.set_item_properties(stats)
		get_node("/root/World/Level/Items").add_child(newItem)
	
	
func _ready():

	var output = []
	#OS.execute('build.cmd', PoolStringArray(Array()), false, output)
	print(output)
	
	
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self,"_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	
	
	var _appender2 = Logger.add_appender(ConsoleAppender.new())
	var _appender1 = Logger.add_appender(FileAppender.new("res://game.log"))
	


