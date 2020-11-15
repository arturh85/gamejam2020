extends Node2D

master var puppet_pos = Vector2()
master var puppet_velocity = Vector2()
master var puppet_rotation = 0 
master var puppet_motion = Vector2()
master var health = 0
master var current_map = ""

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var saveData = {}
func save():
	saveData["x"] = position.x
	saveData["y"] = position.y
	saveData["rotation"] = rotation
	saveData["health"] = health
	saveData["current_map"] = current_map
	
	return saveData

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
