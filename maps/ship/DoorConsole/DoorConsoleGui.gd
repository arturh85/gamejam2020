extends Control

onready var grid = $Panel/Grid


export var scale = 0.3

func open():
	var tilemap = get_node("../../Level/TileMap")
	var level_tilemap = tilemap.duplicate()
	var grid_size = grid.get_rect().size
	level_tilemap.position = Vector2(grid_size.x / 2 - 50, grid_size.y / 2)
	level_tilemap.scale = Vector2(scale, scale)
	grid.add_child(level_tilemap)
		
	var map_objects = get_tree().get_nodes_in_group("minimap_objects")
	
	for item in map_objects:
		pass
	
	var door_objects = get_tree().get_nodes_in_group("doors")
	for item in door_objects:
		var door = item.duplicate()
		door.position.x = level_tilemap.position.x + (door.position.x * scale)
		door.position.y = level_tilemap.position.y + (door.position.y * scale)
		door.scale = Vector2(scale, scale)
		door.call_deferred("finish_close")
		
		# does not work :-(
		var detect = door.get_node("Body")
		detect.connect("mouse_entered", self, "door_mouse_entered", [door])
		detect.connect("mouse_exited", self, "door_mouse_exited", [door])
		detect.connect("input_event", self, "door_mouse_exited", [door])
		
		
		grid.add_child(door)
		
	show()
	
func door_mouse_input(viewport, event, shape_idx, door):
	Logger.info("INPUT")	
	
func door_mouse_entered(door):
	Logger.info("ENTERED")
	door.modulate = "#ff0000"
	
func door_mouse_exited(door):
	Logger.info("EXITED")
	door.modulate = null
	

func close():
	hide()
	for item in grid.get_children():
		grid.remove_child(item)
		item.queue_free()
	
