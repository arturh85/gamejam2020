extends Node2D


var modified_player

func _on_FireRatePowerUp_body_entered(body):
	if body.is_in_group("players") and $RespawnTimer.is_stopped():
		$RespawnTimer.start()
		hide()

		var val = 300
		body.speed += val 
		yield(get_tree().create_timer($EffectTimer.wait_time), "timeout")
		body.speed -= val 

func _on_RespawnTimer_timeout():
	$RespawnTimer.stop()
	show()
