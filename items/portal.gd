extends Node2D

onready var world = $"/root/World"


export var back = false
export var levelName = ""
var level

remotesync func dostuff():
	Logger.info("portal dostuff: " + str(is_network_master()))
	
	for player in world.get_node("Players").get_children():
		player.get_node("AnimationPlayer").play("PortalIn")
		player.lockPlayer()
		
	yield(get_tree().create_timer(0.5), "timeout")
	
	world.get_node("CanvasLayer/Transitions").play("Portal")
	
	yield(get_tree().create_timer(1), "timeout")
	

	var newlevel
	if back:
		newlevel = get_node("/root/World/Level").getHomeLevel()
	else:
		newlevel = get_node("/root/World/Level").getRandomLevel(levelName)
	
	once = false
	
	for player in world.get_node("Players").get_children():
		player.setMap(newlevel)
		
			
var once = false

func _on_body_entered(body):
	if body.is_in_group("players"):
		if once:
			return
		once = true
		rpc("dostuff")
