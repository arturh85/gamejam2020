extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Control_body_entered(body):
	if body.is_in_group("players"):
		body.door_controls_available = true

func _on_Control_body_exited(body):
	if body.is_in_group("players"):
		body.door_controls_available = false
