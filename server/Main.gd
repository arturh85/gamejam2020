extends Node

const DEFAULT_PORT = 10567
const MAX_PEERS = 99

func _ready():	
	
	print("hosting game on port " + String(DEFAULT_PORT))
	var host = NetworkedMultiplayerENet.new()
	host.create_server(DEFAULT_PORT, MAX_PEERS)
	get_tree().set_network_peer(host)
