extends Node2D

onready var players = $Players
onready var minimap = $CanvasLayer/MiniMap
	
var level
	
	
func initStartMap(mapName):
	var start_level = load("res://maps/" + mapName + ".tscn")
	level = start_level.instance()
	load_level(null, null, true)
	
puppet func receive_map(new_level):
	for i in range(0, get_node("Maps").get_child_count()):
		get_child(i).queue_free()
	
	get_node("Maps").add_child(new_level)
	#new_level.set_name("Level") # enforce
	#for player in players.get_children():
	#	player.setMap(new_level)
	#old_level.queue_free()
	#minimap.call_deferred("update_map_markers")
	
func post_start_game():
	#minimap.call_deferred("update_map_markers")
	pass
	
func load_level(target_scene, portal_level, back):
	var new_level
	if target_scene:
		new_level = load("res://maps/" + target_scene + ".tscn").instance()
	elif portal_level:
		new_level = portal_level
	elif back:
		new_level = level
		
	if new_level:
		receive_map(new_level)
