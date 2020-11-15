extends Node2D

onready var world = $"/root/World"

signal on_removed(what)

var minimap_icon = "alert"

var target_scene
var trigger_name
var id

	
func trigger(todo):
	if todo == "new":
		create()
	elif todo == "unset":
		unset()
		
	
func _ready():
	create()
		
func create():
	$Light2D.visible = true
	
func unset():
	$Light2D.visible = false
		
		

	
var once = false

func _on_body_entered(body):
	if body.is_in_group("players"):
		if not once:
			once = true
			activate()
			

func activate():
	#Logger.info("portal activated (master: " + str(is_network_master()) + ")")	
	for player in world.get_node("Players").get_children():
		if player.get_name() == str(get_tree().get_network_unique_id()):
			player.get_node("AnimationPlayer").play("PortalIn")
			player.lockPlayer()	
			
			
	world.get_node("CanvasLayer/Transitions").play("Portal")
	yield(get_tree().create_timer(1.0), "timeout")
	rpc_id(1, "activate_portal", get_tree().get_network_unique_id())
				
	once = false
	
remotesync func changeMap():
	pass
	
func set_portal_properties(portal):
	
	id = portal.id
	set_name(portal.name)
	
	self.position.x = portal.x
	self.position.y = portal.y
	
	target_scene = portal.targetScene
	$Light2D.color = Color(portal.color)
	trigger_name = portal.triggerName
