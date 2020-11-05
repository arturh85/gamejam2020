extends Node2D

enum INTERACTION {
	OFF,
	ONCOLLISION,
	ONUSE
	
}

export var target = ""
export var value = ""
export(INTERACTION) var interaction = INTERACTION.OFF
export var once = false
export var toggle = false
export var toggleValue = ""

var toggleBool = false


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

func _on_Trigger_body_entered(body):
	if body.is_in_group("players"):
		if interaction == INTERACTION.ONCOLLISION:
			execute()
		elif interaction == INTERACTION.ONUSE:
			body.set_trigger(self)
		
func execute():
	if (once and not triggered) or not once:
		toggleBool = not toggleBool
		checkAllNodes($"/root/World/Level")
		if $"../".has_method("triggered"):
			$"../".triggered()
		triggered = true

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
				if (toggle):
					if toggleBool:
						node.trigger(value)
					else:
						node.trigger(toggleValue)
				else:
					node.trigger(value)


func _on_Trigger_body_exited(body):
	if body.is_in_group("players") and interaction == INTERACTION.ONUSE:
			body.unset_trigger()
			
