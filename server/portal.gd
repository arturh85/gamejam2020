extends Node2D


export var targetSceneName = ""
export var randomLevelTemplate = ""
export var createInstance = true
export var back = false
export(Color, RGB) var dcolor = "00f3ff" setget setColor
export var triggerName = ""

var color

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setColor(c):
	color = c
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
