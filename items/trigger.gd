extends Node2D

export var target = ""
export var value = ""
export(Color, RGB) var color = "" setget setColor

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var triggered = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

var initTrigger = false

func setColor(c):
	$Light2D.color = c

func _on_Trigger_body_entered(body):
	if not initTrigger:
		initTrigger = true
		return
		
	if not triggered:
		dotrigger()
		triggered = true
		
func dotrigger():
	$Light2D.visible = true
	checkAllNodes($"/root/World/Level")

func checkAllNodes(node):
	for N in node.get_children():
		if N.get_child_count() > 0:
			checkAllNodes(N)
		checkNode(N)
		
func checkNode(node):
	if node.has_method("trigger"):
		var targets = target.split(";")
		for t in targets:
			if node.trigger_name == t:
				node.trigger(value)
