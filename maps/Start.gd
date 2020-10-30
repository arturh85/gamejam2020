extends Node2D


export (PackedScene) var random_level = load("res://maps/Random.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var randomLevel = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	
	randomLevel["level1"] = random_level.instance()
	randomLevel["level1"].init("level1", self)
	
	pass # Replace with function body.

func getRandomLevel(name):
	return randomLevel[name]


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
