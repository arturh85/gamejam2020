extends Node2D

onready var world = $"/root/World"


export var back = false
export var levelName = ""
export var color = "00f3ff"
var level

	

func setColor(c):
	$Light2D.color = c

remotesync func activate():
	Logger.info("portal activated (master: " + str(is_network_master()) + ")")
	if not world.get_node("Level"): 
		Logger.error("NO LEVEL?!")
	
	for player in world.get_node("Players").get_children():
		player.get_node("AnimationPlayer").play("PortalIn")
		player.lockPlayer()
		
	yield(get_tree().create_timer(0.5), "timeout")
	
	world.get_node("CanvasLayer/Transitions").play("Portal")
	
	yield(get_tree().create_timer(1), "timeout")
	
	var level = world.get_node("Level")
	
	var newlevel
	if back and level.has_method("getHomeLevel"):
		newlevel = level.getHomeLevel()
	else:
		newlevel = level.getRandomLevel(levelName)
		
	world.remove_child(level)
		
	world.add_child(newlevel)
		
	for player in world.get_node("Players").get_children():
		player.setMap(newlevel)
			
	once = false
	
var once = false



func _on_body_entered(body):
	if is_network_master() and body.is_in_group("players"):
		if not once:
			once = true
			rpc("activate")
