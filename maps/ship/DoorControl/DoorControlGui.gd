extends Control

onready var grid = $Panel/Grid


export var scale = 0.3

var hover_door = null
var is_open = false
var real_door = {}

var symbol_by_room = {}

var level_tilemap = null


onready var other_player_marker = $Panel/OtherPlayerMarker
onready var mob_marker = $Panel/MobMarker
# Link object icon setting to Sprite marker.
onready var icons = {"mob": mob_marker, "other_player": other_player_marker}

var markers = {}  # Dictionary of object: marker.

func open():
	var tilemap = get_node("../../Level/TileMap")
	level_tilemap = tilemap.duplicate()
	var grid_size = grid.get_rect().size
	level_tilemap.position = Vector2(grid_size.x / 2 - 50, grid_size.y / 2)
	level_tilemap.scale = Vector2(scale, scale)
	grid.add_child(level_tilemap)
	real_door = {}
	symbol_by_room = {}
	markers = {}
		
	var map_objects = get_tree().get_nodes_in_group("minimap_objects")
	for item in map_objects:
		if item.minimap_icon and icons.has(item.minimap_icon) and icons[item.minimap_icon]:
			var new_marker = icons[item.minimap_icon].duplicate()
			grid.add_child(new_marker)
			new_marker.show()
			markers[item] = new_marker
			if not item.is_connected("on_removed", self, "_on_object_removed"):
				item.connect("on_removed", self, "_on_object_removed")
		
	var room_objects = get_tree().get_nodes_in_group("rooms")
	for room in room_objects:
		if room.has_node("Symbol"):
			var symbol = room.get_node("Symbol").duplicate()
			symbol.position.x = level_tilemap.position.x + (symbol.position.x * scale) + (room.position.x * scale) 
			symbol.position.y = level_tilemap.position.y + (symbol.position.y * scale) + (room.position.y * scale)
			symbol.scale = Vector2(scale * 3, scale * 3)
			symbol_by_room[room] = symbol
			grid.add_child(symbol)			
			
		
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
		
	is_open = true
	show()
	
func _on_object_removed(object):
	# Removes a marker from the map. Connect to object's "removed" signal.
	if object in markers:
		markers[object].queue_free()
		markers.erase(object)
	
func _process(_delta):
	if not is_open:
		return
		
	for item in markers:
		var obj_pos = Vector2(level_tilemap.position.x + (item.position.x * scale), level_tilemap.position.y + (item.position.y * scale))
		markers[item].position = obj_pos
		
	for room in symbol_by_room:
		var symbol = symbol_by_room[room]
		symbol.modulate = Color.red.linear_interpolate(Color.white, room.oxygen / 100)
	
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
	is_open = false
	hide()
	for item in grid.get_children():
		if real_door.has(item):
			real_door[item].disconnect("on_state_changed", self, "door_state_changed")
		grid.remove_child(item)
		item.queue_free()
	level_tilemap = null
