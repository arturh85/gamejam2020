extends Node2D

func _on_body_entered(body):
	if body.is_in_group("players") and $RespawnTimer.is_stopped():
		$RespawnTimer.start()
		hide()
		body.has_weapon2 = true

func _on_RespawnTimer_timeout():
	$RespawnTimer.stop()
	show()
