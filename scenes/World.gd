extends Node2D

var random_level = load("res://maps/Random.tscn")
var start_level = load("res://maps/Start.tscn")

onready var players = $Players
onready var minimap = $CanvasLayer/MiniMap
	
puppet func receive_map(new_level):
	var old_level = get_node("Level")
	remove_child(old_level)
	add_child(new_level)
	new_level.set_name("Level") # enforce
	for player in players.get_children():
		player.setMap(new_level)
	old_level.queue_free()
	minimap.call_deferred("update_map_markers")
	
func load_level(target_scene, levelName, back, rseed):
	var old_level = get_node("Level")
	var new_level
	if target_scene:
		new_level = load(target_scene).instance()
	elif levelName:
		if is_network_master():
			new_level = random_level.instance()
			new_level.init(levelName, rseed)
			rpc("receive_map", new_level)
	elif back:
		new_level = start_level.instance()
		
	if new_level:
		remove_child(old_level)
		add_child(new_level)
		new_level.set_name("Level") # enforce
		for player in players.get_children():
			player.setMap(new_level)
		old_level.queue_free()
		minimap.call_deferred("update_map_markers")
