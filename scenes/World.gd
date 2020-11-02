extends Node2D

var start_level = load("res://maps/Start.tscn")

onready var players = $Players
onready var minimap = $CanvasLayer/MiniMap
	
var level
	
func _ready():
	level = start_level.instance()
	load_level(null, null, true)
	
puppet func receive_map(new_level):
	var old_level = get_node("Level")
	if old_level:
		remove_child(old_level)
	add_child(new_level)
	new_level.set_name("Level") # enforce
	for player in players.get_children():
		player.setMap(new_level)
	#old_level.queue_free()
	minimap.call_deferred("update_map_markers")
	
func post_start_game():
	minimap.call_deferred("update_map_markers")
	
func load_level(target_scene, portal_level, back):
	var old_level = get_node("Level")
	var new_level
	if target_scene:
		new_level = load(target_scene).instance()
	elif portal_level:
		new_level = portal_level
	elif back:
		new_level = level
		
	if new_level:
		receive_map(new_level)
