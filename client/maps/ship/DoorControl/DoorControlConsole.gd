extends HealthBase

var current_player = null

func _on_Control_body_entered(body):
	if body.is_in_group("players") and health > 0:
		body.door_controls_available = true
		current_player = body

func _on_Control_body_exited(body):
	if body.is_in_group("players"):
		body.door_controls_available = false
		current_player = null

func _on_DoorConsole_on_death(by_who):
	$Destroyed.show()
	if current_player:
		current_player.door_controls_available = false
