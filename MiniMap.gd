extends MarginContainer

export (NodePath) var player  # Link to Player node. If this is null, the map will not function.
export var zoom = 1.5 setget set_zoom # Scale multiplier.

# Node references.
onready var grid = $MarginContainer/Grid
onready var player_marker = $MarginContainer/Grid/PlayerMarker
onready var mob_marker = $MarginContainer/Grid/MobMarker
onready var alert_marker = $MarginContainer/Grid/AlertMarker
# Link object icon setting to Sprite marker.
onready var icons = {"mob": mob_marker, "alert": alert_marker}

var grid_scale  # Calculated world to map scale.
var markers = {}  # Dictionary of object: marker.


func _ready():
	# Center the player marker in the grid.
	player_marker.position = grid.rect_size / 2
	# Find the scale factor for marker placement.
	grid_scale = grid.rect_size / (get_viewport_rect().size * zoom)
	# Create markers for all objects.
	var map_objects = get_tree().get_nodes_in_group("minimap_objects")
	for item in map_objects:
		var new_marker = icons[item.minimap_icon].duplicate()
		grid.add_child(new_marker)
		new_marker.show()
		markers[item] = new_marker

func _process(delta):
	# If no player is assigned, do nothing.
	if !player:
		return
	# Arrow texture points upwards, so add 90 degrees.
	var player_node = get_node(player)
	var group_node = player_node.find_node("Group")
	player_marker.rotation = group_node.rotation + PI/2
	for item in markers:
		var obj_pos = (item.position - player_node.position) * grid_scale + grid.rect_size / 2

		#print("grid.rect_position", grid.rect_position)
		var grid_radius = grid.get_rect().size[0] / 2
		
		var grid_center = Vector2(grid_radius, grid_radius)
		var obj_direction = obj_pos - grid_center
		var obj_distance = obj_direction.length()
		# If marker is outside grid, hide or shrink it.
		
		#print("distance ", obj_distance, " radius ", grid_radius)
		if obj_distance < grid_radius:
		#if grid.get_rect().has_point(obj_pos + grid.rect_position):
			markers[item].scale = Vector2(3, 3)
#			markers[item].show()
		else:
			markers[item].scale = Vector2(0.75, 0.75)
#			markers[item].hide()
		# Don't draw markers outside grid rectangle.
		
		if obj_distance > grid_radius:
			obj_pos = grid_center + (obj_direction.normalized() * grid_radius)
		
		#obj_pos.x = clamp(obj_pos.x, 0, grid.rect_size.x)
		#obj_pos.y = clamp(obj_pos.y, 0, grid.rect_size.y)
		markers[item].position = obj_pos
		#print("obj_distance", obj_distance)
	
	
func _on_object_removed(object):
	# Removes a marker from the map. Connect to object's "removed" signal.
	if object in markers:
		markers[object].queue_free()
		markers.erase(object)


func set_zoom(value):
	# Adjust zoom value and recalculate scale.
	zoom = clamp(value, 0.5, 5)
	grid_scale = grid.rect_size / (get_viewport_rect().size * zoom)
	
	
func _on_MiniMap_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_WHEEL_UP:
			self.zoom += 0.1
		if event.button_index == BUTTON_WHEEL_DOWN:
			self.zoom -= 0.1


