extends Node2D

onready var world = $"/root/World"
var random_level = load("res://maps/Random.tscn")

signal on_removed(what)

var minimap_icon = "alert"
export(String, FILE) var target_scene
export var randomLevelTemplate = ""
export var createInstance = false
export var back = false
export(Color, RGB) var color = "00f3ff" setget setColor
var level = null
export var trigger_name = ""

func setColor(c):
	$Light2D.color = c
	
func setInstance(instance):
	$Light2D.visible = true
	level = instance
	
func trigger(todo):
	if todo == "new":
		create()
	elif todo == "unset":
		unset()
		
	
func _ready():
	if back:
		$Light2D.visible = true
	if createInstance:
		create()
		
func create():
	if target_scene:
		level = load(target_scene).instance()
	else:
		level = random_level.instance()
		level.init(randomLevelTemplate, randi())
	$Light2D.visible = true
	
func unset():
	$Light2D.visible = false
	if level:
		level.queue_free()
	level = null
		
		

remotesync func activate():
	#Logger.info("portal activated (master: " + str(is_network_master()) + ")")	
	for player in world.get_node("Players").get_children():
		player.get_node("AnimationPlayer").play("PortalIn")
		player.lockPlayer()		
	yield(get_tree().create_timer(0.5), "timeout")	
	world.get_node("CanvasLayer/Transitions").play("Portal")	
	yield(get_tree().create_timer(1.1), "timeout")
	
	world.load_level(target_scene, level, back)
	once = false
	
var once = false

func _on_body_entered(body):
	if body.is_in_group("players"):
		if not level and not back:
			Logger.error("invalid portal without instance nor back")
			return
		
		if not once:
			once = true
			rpc("activate")
