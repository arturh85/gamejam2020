extends Node2D

func _on_Control_body_entered(body):
	if body.is_in_group("players"):
		body.door_controls_available = true

func _on_Control_body_exited(body):
	if body.is_in_group("players"):
		body.door_controls_available = false
