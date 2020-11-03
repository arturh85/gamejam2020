extends Control

onready var grid = $Panel/Grid


export var scale = 0.3


var real_door = {}

func open():
	var tilemap = get_node("../../Level/TileMap")
	var level_tilemap = tilemap.duplicate()
	var grid_size = grid.get_rect().size
	level_tilemap.position = Vector2(grid_size.x / 2 - 50, grid_size.y / 2)
	level_tilemap.scale = Vector2(scale, scale)
	grid.add_child(level_tilemap)
	real_door = {}
		
	var map_objects = get_tree().get_nodes_in_group("minimap_objects")
	
	for item in map_objects:
		pass
	
	var door_objects = get_tree().get_nodes_in_group("doors")
	for item in door_objects:
		var door = item.duplicate()
		door.set_process(false)
		door.set_physics_process(false)
		if door.locked:
			door.modulate = "#dd0000"
		elif door.opened:
			door.modulate = "#00dd00"
		door.position.x = level_tilemap.position.x + (door.position.x * scale)
		door.position.y = level_tilemap.position.y + (door.position.y * scale)
		door.scale = Vector2(scale, scale)
		
		item.connect("on_state_changed", self, "door_state_changed", [door])		
		real_door[door] = item
		var detect = door.get_node("Detect")
		detect.connect("mouse_entered", self, "door_mouse_entered", [door])
		detect.connect("mouse_exited", self, "door_mouse_exited", [door])
		detect.connect("input_event", self, "door_mouse_input", [door])		
		grid.add_child(door)		
		
	show()
	
func door_mouse_input(viewport, event: InputEvent, shape_idx, door):
	if event is InputEventMouseButton and event.pressed:
		var real = real_door[door]
		real.rpc("normal_click")	
	
func door_state_changed(real, fake):
	if not real or not fake:
		return
	fake.opened = real.opened
	fake.set_process(false)
	fake.set_state(real.state)
	
func door_mouse_entered(door):
	if door.locked:
		door.modulate = "#ff0000"
	elif door.opened:
		door.modulate = "#00ff00"
	else:
		door.modulate = "#00ff00"
	
func door_mouse_exited(door):
	if door.locked:
		door.modulate = "#dd0000"
	elif door.opened:
		door.modulate = "#00dd00"
	else:
		door.modulate = "#ffffff"
	

func close():
	hide()
	for item in grid.get_children():
		if real_door.has(item):
			real_door[item].disconnect("on_state_changed", self, "door_state_changed")
		grid.remove_child(item)
		item.queue_free()
	
