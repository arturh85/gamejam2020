extends Node2D

var random_level = load("res://maps/Random.tscn")
var start_level = load("res://maps/Start.tscn")

onready var players = $Players
onready var minimap = $CanvasLayer/MiniMap

var randomLevel = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	#Logger.info("generated random level1")
	#randomLevel["level1"] = random_level.instance()
	#randomLevel["level1"].init("level1", self)
	
	pass # Replace with function body.

func getRandomLevel(name):
	return randomLevel[name]
	
func load_level(target_scene, levelName, back, rseed):
	var old_level = get_node("Level")
	
	var new_level
	if target_scene:
		new_level = load(target_scene).instance()
	elif levelName:
		new_level = random_level.instance()
		new_level.init(levelName, rseed)
	elif back:
		new_level = start_level.instance()
		
			
	remove_child(old_level)
	add_child(new_level)
	new_level.set_name("Level") # enforce
	for player in players.get_children():
		player.setMap(new_level)
	old_level.queue_free()
	minimap.call_deferred("update_map_markers")
