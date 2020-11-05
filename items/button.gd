extends "res://items/trigger.gd"

export(Color, RGB) var color = "ffffff" setget setColor

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Trigger.target = target
	$Trigger.value = value
	$Trigger.interaction = interaction
	$Trigger.once = once
	$Trigger.toggle = toggle
	$Trigger.toggleValue = toggleValue

func setColor(col):
	$Light2D.color = col

func triggered():
	if once:
		$Light2D.visible = true
	elif toggle:
		$Light2D.visible = not $Light2D.visible
	else:
		$Light2D.visible = true
		yield(get_tree().create_timer(0.5), "timeout")
		$Light2D.visible = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
