extends Control

onready var grid = $Panel/Grid


export var scale = 0.3

var hover_door = null
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
		modulate_door(door, false)
		door.position.x = level_tilemap.position.x + (door.position.x * scale)
		door.position.y = level_tilemap.position.y + (door.position.y * scale)
		door.scale = Vector2(scale, scale)
		
		item.connect("on_state_changed", self, "door_state_changed", [door])		
		item.connect("on_param_changed", self, "door_param_changed", [door])		
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
		if event.button_index == 2:
			real.rpc("alt_click")
		else:
			real.rpc("normal_click")
			
		call_deferred("modulate_door", door, door == hover_door)
	
func door_state_changed(real, fake):
	if not real or not fake:
		return
	fake.set_process(false)
	fake.set_state(real.state)
	
func door_param_changed(real, fake):
	if not real or not fake:
		return
	fake.opened = real.opened
	fake.locked = real.locked

func door_mouse_entered(door):
	hover_door = door
	modulate_door(door, true)
	
func door_mouse_exited(door):
	hover_door = null
	modulate_door(door, false)
		
		
func modulate_door(door, hover = false):
	if door.locked:
		if hover:
			door.modulate = "#ff0000"
		else:
			door.modulate = "#dd0000"
	elif door.opened:
		if hover:
			door.modulate = "#00ff00"
		else:
			door.modulate = "#00dd00"
	else:
		if hover:
			door.modulate = "#00ff00"
		else:
			door.modulate = "#ffffff"
	

func close():
	hide()
	for item in grid.get_children():
		if real_door.has(item):
			real_door[item].disconnect("on_state_changed", self, "door_state_changed")
		grid.remove_child(item)
		item.queue_free()
	
