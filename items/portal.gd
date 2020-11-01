extends Node2D

onready var world = $"/root/World"


export(String, FILE) var target_scene
export var back = false
export var levelName = ""
export(Color, RGB) var color = "00f3ff" setget setColor
var level

func setColor(c):
	$Light2D.color = c

remotesync func activate(rseed):
	Logger.info("portal activated (master: " + str(is_network_master()) + ")")	
	for player in world.get_node("Players").get_children():
		player.get_node("AnimationPlayer").play("PortalIn")
		player.lockPlayer()		
	yield(get_tree().create_timer(0.5), "timeout")	
	world.get_node("CanvasLayer/Transitions").play("Portal")	
	yield(get_tree().create_timer(1.1), "timeout")
	
	world.load_level(target_scene, levelName, back, rseed)
	once = false
	
var once = false

func _on_body_entered(body):
	if is_network_master() and body.is_in_group("players"):
		if not levelName and not target_scene and not back:
			Logger.error("invalid portal without level nor scene nor back")
			return
		
		if not once:
			once = true
			rpc("activate", randi())
