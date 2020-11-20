extends Node2D

onready var players = $Players
onready var minimap = $CanvasLayer/MiniMap
	
func post_start_game():
	#minimap.call_deferred("update_map_markers")
	pass
	
func load_level(target_scene):
	
	for i in range(0, get_node("Maps").get_child_count()):
		get_node("Maps").get_child(i).queue_free()
	
	var new_level = load("res://maps/" + target_scene + ".tscn").instance()
	#new_level.z_index = -1
	get_node("Maps").add_child(new_level)
