extends Node2D

onready var players = $Players
onready var minimap = $CanvasLayer/MiniMap
	
func post_start_game():
	#minimap.call_deferred("update_map_markers")
	pass
	
func load_level(target_scene, tileMap):
	
	for map in get_node("Maps").get_children():
		get_node("Maps").remove_child(map)
		map.queue_free()
	
	var new_level
	if target_scene.substr(0, 6) == "Random":
		new_level = load("res://maps/Random.tscn").instance()
		new_level.init(target_scene, tileMap)
	else:
		new_level = load("res://maps/" + target_scene + ".tscn").instance()
	
	
	get_node("Maps").add_child(new_level)
	new_level.name = target_scene
